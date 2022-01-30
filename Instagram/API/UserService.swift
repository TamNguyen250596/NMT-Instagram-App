//
//  UserService.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 10/01/2022.
//

import Firebase

struct UserService {
    static func fetchUser(withUserID uid: String, completion: @escaping (User) -> Void) {
        Collection_User.document(uid).getDocument(completion: { (snapshot, error) in
            
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            completion(user)
        })
    }
    
    static func fetchAllUsers(completion: @escaping ([User]) -> Void) {
        Collection_User.getDocuments(completion: { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            let users = snapshot.documents.map({ User(dictionary: $0.data()) })
            completion(users)
        })
    }
    
    static func follow(uid: String, completion: @escaping CompletionHandlerOptionalErrorToVoid) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        Collection_Following.document(currentUid).collection(User_Following).document(uid).setData([:], completion: { (error) in
            
            Collection_Followers.document(uid).collection(User_Followers).document(currentUid).setData([:], completion: completion)
        })
    }
    
    static func unfollow(uid: String, completion: @escaping CompletionHandlerOptionalErrorToVoid) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        Collection_Following.document(currentUid).collection(User_Following).document(uid).delete(completion: { (error) in
            
            Collection_Followers.document(uid).collection(User_Followers).document(currentUid).delete(completion: completion)
        })
    }
    
    static func checkIfUserIsFollowed(uid: String, completion: @escaping CompletionHandlerBoolToVoid) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        Collection_Following.document(currentUid).collection(User_Following).document(uid).getDocument(completion: { (snapshot, error) in
            
            guard let isFollowed = snapshot?.exists else {return}
            completion(isFollowed)
        })
    }
    
    static func fetchUserStats(uid: String, completion: @escaping (UserStats) -> Void) {
        Collection_Followers.document(uid).collection(User_Followers).getDocuments(completion: {
            (snapshot, _) in
            
            let followers = snapshot?.documents.count ?? 0
            
            Collection_Following.document(uid).collection(User_Following).getDocuments(completion: {
                (snapshot, _) in
                
                let following = snapshot?.documents.count ?? 0
                
                Collection_Post.whereField("ownerUid", isEqualTo: uid).getDocuments(completion: { (snapshot, error) in
                    
                    let posts = snapshot?.documents.count ?? 0
                    
                    let userStats = UserStats(numberOfFollowers: followers,
                                              numberOfFollowing: following,
                                              numberOfPosts: posts)
                    
                    completion(userStats)
                })
            })
        })
    }
}
