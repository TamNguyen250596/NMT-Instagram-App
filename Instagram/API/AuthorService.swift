//
//  AuthorService.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 07/01/2022.
//

import Foundation
import Firebase

struct AuthorService {
    static func loginUser(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
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
