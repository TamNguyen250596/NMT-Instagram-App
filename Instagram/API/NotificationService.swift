//
//  NotificationService.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 18/01/2022.
//

import Firebase

struct NotificationService {
    static func uploadNotification(fromCurrentUser poster: User, toUser receiverId: String, type: NotificationType, post: Post? = nil) {
        guard let cuurentId = Auth.auth().currentUser?.uid else {return}
        guard receiverId != cuurentId else {return}
        let docRef = Collection_Notification
            .document(receiverId).collection(User_Notifications).document()
        
        var data: [String: Any] = ["id": docRef.documentID,
                                   "timestamp": Timestamp(date: Date()),
                                   "uid": cuurentId,
                                   "profileImgUrl": poster.profileImage,
                                   "userName": poster.userName,
                                   "type": type.rawValue]
        
        if let post = post {
            data["postId"] = post.postId
            data["postImageUrl"] = post.imageUrl
        }
        
        docRef.setData(data)
    }
    
    static func fetchNotifications(completion: @escaping ([Notification]) -> Void){
        guard let currentId = Auth.auth().currentUser?.uid else {return}
        
        Collection_Notification.document(currentId).collection(User_Notifications).order(by: "timestamp", descending: true).getDocuments(completion: { (snapshot, error) in
            
            guard let snapshots = snapshot?.documents else {return}
            
            let notifications = snapshots.map({ Notification(dictionary: $0.data())})
            completion(notifications)
        })
    }
}
