//
//  CommentService.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 14/01/2022.
//

import Firebase

struct CommentService {
    
    static func postComment(postID: String, user: User, comment: String, completion: @escaping CompletionHandlerOptionalErrorToVoid) {
        
        let data: [String: Any] = ["commentTxt": comment,
                                   "timestamp": Timestamp(date: Date()),
                                   "uid": user.uid,
                                   "imageUrl": user.profileImage,
                                   "userName": user.userName]
        
        Collection_Post.document(postID).collection(Post_Comments).addDocument(data: data, completion: completion)
    }
    
    static func fetchComments(forPost postID: String, completion: @escaping ([Comment]) -> Void) {
        var comments = [Comment]()
        let query = Collection_Post.document(postID)
            .collection(Post_Comments)
            .order(by: "timestamp", descending: true)
        
        query.addSnapshotListener({ (snapshot, error) in
            
            snapshot?.documentChanges.forEach({ (change) in
                
                if change.type == .added {
                    let data = change.document.data()
                    let comment = Comment(dictionary: data)
                    comments.append(comment)
                }
            })
            completion(comments)
        })
    }
}
