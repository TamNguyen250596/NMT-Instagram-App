//
//  ProfileCellViewModel.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 13/01/2022.
//

import Foundation

struct ProfileCellViewModel {
    private var post: Post
    
    var imageUrl: URL? {
        return URL(string: post.imageUrl)
    }
    
    init(post: Post) {
        self.post = post
    }
}
