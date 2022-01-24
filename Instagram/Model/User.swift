//
//  User.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 10/01/2022.
//

import Foundation
import Firebase

struct User {
    public private(set) var email: String
    public private(set) var fullName: String
    public private(set) var profileImage: String
    public private(set) var userName: String
    public private(set) var uid: String
    
    var isFollowed = false
    
    var userStats = UserStats()
    
    var isCurrentUser: Bool {return Auth.auth().currentUser?.uid == uid}
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullName = dictionary["fullname"] as? String ?? ""
        self.profileImage = dictionary["profileImageUrl"] as? String ?? ""
        self.userName = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}

struct UserStats {
    var numberOfFollowers = 0
    var numberOfFollowing = 0
    var numberOfPosts = 0
}
