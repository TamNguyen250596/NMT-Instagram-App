//
//  UserLikedCellVM.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 18/01/2022.
//

import Foundation

struct UserLikedCellViewModel {
    private var liked: Liked
    
    init(liked: Liked) {
        self.liked = liked
    }
    
    var profileImageUrl: URL? {
        return URL(string: liked.imageUrl)
    }
    
    var userName: String {
        return liked.userName
    }
    
}
