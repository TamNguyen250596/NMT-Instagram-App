//
//  FeedCellViewModel.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 13/01/2022.
//

import UIKit

struct FeedCellViewModel {
    var post: Post
    
    var ownerImgUrl: URL? {
        return URL(string: post.ownerImageUrl)
    }
    
    var imageUrl: URL? {
        return URL(string: post.imageUrl)
    }
    
    var ownerUserName: String {
        return post.ownerUserName
    }
    
    var caption: String {
        return post.caption
    }
    
    var likes: String {
        if post.likes == 0 {
            return ""
        } else if post.likes == 1 {
            return "1 like"
        } else {
            return "\(post.likes) likes"
        }
    }
    
    var colorOfLikeBtn: UIColor {
        return post.isLiked ? #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1) : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    var imageOfLikeBtn: UIImage? {
        return post.isLiked ? UIImage(named: "like_selected") : UIImage(named: "like_unselected")
    }
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        return formatter.string(from: post.timestamp.dateValue(), to: .now)
    }

    init(post: Post) {
        self.post = post
    }
}
