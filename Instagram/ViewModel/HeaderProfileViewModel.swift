//
//  HeaderProfileViewModel.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 10/01/2022.
//

import UIKit

struct HeaderProfileViewModel {
    var user: User
    
    var fullName: String {
        return user.fullName
    }

    var profileImageUrl: URL? {
        return URL(string: user.profileImage)
    }
    
    var followButtonText: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var followButtonBackground: UIColor {
        return user.isCurrentUser ? .white : .systemBlue
    }
    
    var followBottunTextColor: UIColor {
        return user.isCurrentUser ? .black : .white
    }
    
    var posts: String {
        return String(user.userStats.numberOfPosts)
    }
    
    var followers: String {
        return String(user.userStats.numberOfFollowers)
    }
    
    var following: String {
        return String(user.userStats.numberOfFollowing)
    }
    
    init(user: User) {
        self.user = user
    }
}
