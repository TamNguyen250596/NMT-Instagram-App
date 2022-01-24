//
//  Notification.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 18/01/2022.
//

import Firebase

enum NotificationType: Int {
    case like
    case follow
    case comment
    
    var notificationMessage: String {
        switch self {
        case .like:
            return "liked your post:"
        case .follow:
            return "started following you:"
        case .comment:
            return "comment on your post:"
        }
    }
}

struct Notification {
    public private(set) var id: String
    public private(set) var postId: String
    public private(set) var postImageUrl: String
    public private(set) var timestamp: Timestamp
    public private(set) var type: NotificationType
    public private(set) var uid: String
    public private(set) var profileUserUrl: String
    public private(set) var userName: String
    var isFollowed = false
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.postId = dictionary["postId"] as? String ?? ""
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileUserUrl = dictionary["profileImgUrl"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
    }
}
