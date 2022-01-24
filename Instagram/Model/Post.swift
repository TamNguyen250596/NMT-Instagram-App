//
//  Post.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 13/01/2022.
//

import Firebase

struct Post {
    public private(set) var postId: String
    public private(set) var caption: String
    public private(set) var imageUrl: String
    public private(set) var ownerId: String
    public private(set) var timestamp: Timestamp
    public private(set) var ownerImageUrl: String
    public private(set) var ownerUserName: String
    var likes: Int
    var isLiked = false

    init(postId: String, dictionary: [String: Any]) {
        self.postId = postId
        self.caption = dictionary["caption"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.ownerId = dictionary["ownerUid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.ownerImageUrl = dictionary["ownerImageUrl"] as? String ?? ""
        self.ownerUserName = dictionary["ownerUserName"] as? String ?? ""
    }
}

