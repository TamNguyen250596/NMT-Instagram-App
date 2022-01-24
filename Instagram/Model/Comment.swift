//
//  Comment.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 14/01/2022.
//

import Firebase

struct Comment {
    public private(set) var commentTxt: String
    public private(set) var imageUrl: String
    public private(set) var timestamp: Timestamp
    public private(set) var userName: String
    public private(set) var uid: String
    
    init(dictionary: [String: Any]) {
        self.commentTxt = dictionary["commentTxt"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.userName = dictionary["userName"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
