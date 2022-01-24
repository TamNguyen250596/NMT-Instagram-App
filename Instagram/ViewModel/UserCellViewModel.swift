//
//  UserCellViewModel.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 10/01/2022.
//

import Foundation

struct UserCellViewModel {
    private var user: User
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImage)
    }
    
    var userName: String {
        return user.fullName
    }
    
    var fullName: String {
        return user.fullName
    }
    
    init(user: User) {
        self.user = user
    }
}
