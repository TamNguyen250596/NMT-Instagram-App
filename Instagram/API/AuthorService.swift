//
//  AuthorService.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 07/01/2022.
//

import Foundation
import Firebase
import GoogleSignIn
import FBSDKCoreKit

struct AuthorService {
    static func loginUser(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func loginByGoogle(presentingVC: UIViewController, completion: @escaping CompletionHandlerOptionalErrorToVoid) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: presentingVC, callback: { (user, error) in
            
            if let error = error {
                print("DEBUG failed to user \(error.localizedDescription)")
                return
              }
            
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken
            else {return}
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential, completion: { (authResult, error) in
                
                if let error = error {
                    print("DEBUG failed to user \(error.localizedDescription)")
                    return
                  }
                
                guard let authResult = authResult else {return}
                let uid = authResult.user.uid
                
                let data: [String: Any] =
                ["email": authResult.user.email ?? "",
                "fullname": authResult.user.displayName ?? "",
                "profileImageUrl": authResult.user.photoURL?.absoluteString ?? "",
                "uid": authResult.user.uid,
                "username": authResult.user.displayName ?? ""]
                

                print("successfully saved - let's login")
                                                              
                Collection_User.document(uid).setData(data, completion: completion)
            })
        })
    }
    
    static func loginByFacebook(completion: @escaping CompletionHandlerOptionalErrorToVoid) {
        
        guard let tokenString = AccessToken.current?.tokenString else {return}
        let credential = FacebookAuthProvider.credential(
            withAccessToken: tokenString)
        
        Auth.auth().signIn(with: credential, completion: { (authResult, error) in
            
            if let error = error {
                print("DEBUG failed to user \(error.localizedDescription)")
                return
              }
            
            guard let authResult = authResult else {return}
            let uid = authResult.user.uid
            
            let data: [String: Any] =
            ["email": authResult.user.email ?? "",
            "fullname": authResult.user.displayName ?? "",
            "profileImageUrl": authResult.user.photoURL?.absoluteString ?? "",
            "uid": authResult.user.uid,
            "username": authResult.user.displayName ?? ""]
            

            print("successfully saved - let's login")
                                                          
            Collection_User.document(uid).setData(data, completion: completion)
        })
        
    }
    
    static func registerUser(withCredential: AuthorIDs, completion: @escaping CompletionHandlerOptionalErrorToVoid) {
        
        ImageUploader.uploadImage(image: withCredential.profileImage, completion: { (imgUrl) in
            
            Auth.auth().createUser(withEmail: withCredential.email, password: withCredential.password, completion: { (result, error) in
                if let error = error {
                    print("DEBUG failed to user \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else {return}
                
                let data: [String: Any] = ["email": withCredential.email,
                                           "fullname": withCredential.fullName,
                                           "profileImageUrl": imgUrl,
                                           "uid": uid,
                                           "username": withCredential.userName]
                
                Collection_User.document(uid).setData(data, completion: completion)
            })
        })
    }
    
    static func resetPassword(newEmail: String, completion: @escaping SendPasswordResetCallback) {
        Auth.auth().sendPasswordReset(withEmail: newEmail, completion: completion)
    }
}
