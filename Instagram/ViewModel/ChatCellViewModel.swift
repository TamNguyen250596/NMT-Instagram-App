//
//  ChatCellViewModel.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 26/01/2022.
//

import UIKit

struct ChatCellViewModel {
    
    private var message: Message

    init(message: Message) {
        self.message = message
    }
    
    var imgUrl: URL? {
        return URL(string: message.senderProfile?.profileImage ?? "")
    }
    
    var userName: String {
        return message.boxChatIsShouldOnRight ? "" : message.senderProfile?.userName ?? ""
    }
    
    func attributedTitle() -> NSMutableAttributedString {
        
        let attsLine1: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.darkText, .font: UIFont.boldSystemFont(ofSize: 14)]
        let attributedTitle = NSMutableAttributedString(string: userName + " ", attributes: attsLine1)
        
        let attsLine2: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.darkGray, .font: UIFont.boldSystemFont(ofSize: 14)]
        attributedTitle.append(NSAttributedString(string: message.content, attributes: attsLine2))
        
        return attributedTitle
    }
    
    func dynamicCellHeigh(forWidth width: CGFloat) -> CGFloat {
        
        let constraintRect = CGSize(width: width - 180, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = attributedTitle().boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        let height = ceil(boundingBox.height) + 20
         
        if height <= 70 {
            return 70
        } else {
            return height
        }
    }
    
}
