//
//  Message.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 26/01/2022.
//

import UIKit
import Firebase

struct Message {
    public private(set) var senderUid: String
    public private(set) var content: String
    public private(set) var timestamp: Timestamp
    
    var senderProfile: User?
    var boxChatIsShouldOnRight: Bool {
        return Auth.auth().currentUser?.uid == senderUid ? true : false
    }
    
    init(dictionary: [String:Any]) {
        
    self.senderUid = dictionary["sender"] as? String ?? ""
    self.content = dictionary["content"] as? String ?? ""
    self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())

    }
}

