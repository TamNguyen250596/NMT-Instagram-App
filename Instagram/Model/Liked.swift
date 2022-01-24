//
//  Liked.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 17/01/2022.
//

import Firebase

struct Liked {
    public private(set) var timestamp: Timestamp
    public private(set) var uid: String
    public private(set) var imageUrl: String
    public private(set) var userName: String
    
    init(dictionary: [String: Any]) {
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.uid = dictionary["uid"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
    }
}
