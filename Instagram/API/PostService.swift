//
//  PostService.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 12/01/2022.
//

import UIKit
import Firebase

struct PostService {
    static func postUserNews(caption: String, image: UIImage, user: User, completion: @escaping CompletionHandlerOptionalErrorToVoid) {

        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        

        ImageUploader.uploadImageForPostService(image: image, completion: { (imgUrl) in
            
            let data: [String: Any] = ["caption": caption,
                                       "imageUrl": imgUrl,
                                       "likes": 0,
                                       "ownerUid": currentUid,
                                       "timestamp": Timestamp(date: Date()),
                                       "ownerImageUrl": user.profileImage,
                                       "ownerUserName": user.userName]
            
            let documentRef = Collection_Post.addDocument(data: data, completion: completion)
            
            self.sharePostToFollower(postId: documentRef.documentID)
        })
    }
    
    static func fetchAllPosts(completion: @escaping ([Post]) -> Void) {
        Collection_Post.order(by: "timestamp", descending: true).getDocuments(completion: { (snapshot, error) in
            
            guard let document = snapshot?.documents else {return}
            
            let posts = document.map({ Post(postId: $0.documentID, dictionary: $0.data()) })
            
            completion(posts)
        })
    }
    
    static func fetchPosts(forUser uid: String, completion: @escaping ([Post]) -> Void) {
        let query = Collection_Post
            .whereField("ownerUid", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
        
        query.getDocuments(completion: { (snapshot, error) in
            
            guard let documents = snapshot?.documents else {return}
            
            let posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data())})
            completion(posts)
        })
    }
    
    static func compilePostID(uid: String, didFollow: Bool) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        guard uid != currentUid else {return}
        
        let query = Collection_Post
            .whereField("ownerUid", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
        
        query.getDocuments(completion: { (snapshot, error) in
            guard let documents = snapshot?.documents else {return}
            
            let postIDs = documents.map({ $0.documentID })
            
            postIDs.forEach({ (postID) in
                
                if didFollow {
                    Collection_User.document(currentUid).collection(User_Feeds).document(postID).setData([:])
                } else {
                    Collection_User.document(currentUid).collection(User_Feeds).document(postID).delete()
                }
            })
        })
    }
    
    static func updateUserFeedAfterFollowed(completion: @escaping ([Post]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        var posts = [Post]()
        
        Collection_User.document(currentUid).collection(User_Feeds).getDocuments(completion: {(snapshot, _) in
            
            guard let documents = snapshot?.documents else {return}
            
            let postIDs = documents.map({ $0.documentID })
            
            postIDs.forEach({ (postID) in
                
                Collection_Post.document(postID).getDocument(completion: { (snapshot, _) in
                    
                    guard let dictionary = snapshot?.data() else {return}
                    guard let documentID = snapshot?.documentID else {return}
                    
                    let post = Post(postId: documentID, dictionary: dictionary)
                    posts.append(post)
                    
                    if posts.count > 1 {
                        
                        posts.sort(by: { (post1, post2) in
                            return post1.timestamp.dateValue() > post2.timestamp.dateValue()
                        })
                    }

                    completion(posts)
                })

            })
        })
    }
    
    private static func sharePostToFollower(postId: String) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        Collection_Followers.document(currentUid).collection(User_Followers).getDocuments(completion: { (snapshots, _) in
            
            guard let documents = snapshots?.documents else {return}
            
            documents.forEach({ (document) in
                
                Collection_User.document(document.documentID).collection(User_Feeds).document(postId).setData([:])
            })
            Collection_User.document(currentUid).collection(User_Feeds).document(postId).setData([:])
        })
    }
    
}
