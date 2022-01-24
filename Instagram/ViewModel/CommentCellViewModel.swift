//
//  CommentCellViewModel.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 14/01/2022.
//

import UIKit

struct CommentCellViewModel {
    private var comment: Comment
    
    var avatarImg: URL? {
        return URL(string: comment.imageUrl)
    }

    init(comment: Comment) {
        self.comment = comment
    }
    
    func attributedTitle() -> NSMutableAttributedString {
        
        let attsLine1: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.darkText, .font: UIFont.boldSystemFont(ofSize: 14)]
        let attributedTitle = NSMutableAttributedString(string: comment.userName + "  ", attributes: attsLine1)
        
        let attsLine2: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.darkGray, .font: UIFont.boldSystemFont(ofSize: 14)]
        attributedTitle.append(NSAttributedString(string: comment.commentTxt, attributes: attsLine2))
        
        return attributedTitle
    }
    
    func dynamicCellHeigh(forWidth width: CGFloat) -> CGFloat {
        
        let constraintRect = CGSize(width: width - 90, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = attributedTitle().boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        let height = ceil(boundingBox.height) + 20
         
        if height <= 70 {
            return 70
        } else {
            return height
        }
    }
    
}
