//
//  LikeService.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 17/01/2022.
//

import Firebase

struct LikeService {
    static func like(forPost post: Post, user: User, completion: @escaping CompletionHandlerOptionalErrorToVoid) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let data : [String: Any] = ["timestamp": Timestamp(date: Date()),
                                    "uid": currentUid,
                                    "imageUrl": user.profileImage,
                                    "userName": user.userName]
        
        Collection_Post.document(post.postId).updateData(["likes": post.likes + 1])
        
        Collection_Post.document(post.postId).collection(Post_Likes).document(currentUid).setData(data, completion:{
            (error) in
            
            Collection_User.document(currentUid).collection(User_Likes).document(post.postId).setData([:], completion: completion)
        })
    }
    
    static func unlike(forPost post: Post, completion: @escaping CompletionHandlerOptionalErrorToVoid) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        Collection_Post.document(post.postId).updateData(["likes": post.likes - 1])
        
        Collection_Post.document(post.postId).collection(Post_Likes).document(currentUid).delete(completion: { (error) in
        
            Collection_User.document(currentUid).collection(User_Likes).document(post.postId).delete(completion: completion)
        })
    }
    
    static func checkIfUserLiked(forPost post: Post, completion: @escaping CompletionHandlerBoolToVoid) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        guard post.likes > 0 else {return}
        
        Collection_User.document(currentUid).collection(User_Likes).document(post.postId).getDocument(completion: { (snapshot, error) in
            guard let isLiked = snapshot?.exists else {return}
            completion(isLiked)
        })
    }
    
    static func fetchUsersLiked(forPost post: Post, completion: @escaping ([Liked]) -> Void) {
        Collection_Post.document(post.postId).collection(Post_Likes).order(by: "timestamp", descending: true).getDocuments(completion: { (snapshot, error) in
            guard let document = snapshot?.documents else {return}
            
            let liked = document.map({ Liked(dictionary: $0.data()) })
            completion(liked)
        })
    }
}
