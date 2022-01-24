//
//  NotificationCellViewModel.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 18/01/2022.
//

import Firebase
import UIKit

struct NotificationCellViewModel {
    var notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    var postImgUrl: URL? {
        return URL(string: notification.postImageUrl)
    }
    
    var profileImgUrl: URL? {
        return URL(string: notification.profileUserUrl)
    }
    
    var postImgIsShouldHide: Bool {
        return notification.type == .follow ? true : false
    }
    
    var isFollowed: String {
        return notification.isFollowed ? "Following" : "Follow"
    }
    
    var backgroundColor: UIColor {
        return notification.isFollowed ? .white : .systemBlue
    }
    
    var tintColor: UIColor {
        return notification.isFollowed ? .darkText : .white
    }
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: notification.timestamp.dateValue(), to: .now)
    }
    
    var infoTxt: NSAttributedString {
        let username = notification.userName + " "
        let message = notification.type.notificationMessage
        
        let attributedText = NSMutableAttributedString(
            string: username,
            attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSMutableAttributedString(
            string: message,
            attributes: [.font: UIFont.systemFont(ofSize: 12),
                         .foregroundColor: UIColor.lightGray]))
        
        attributedText.append(NSMutableAttributedString(
            string: " \(timestampString ?? "")",
            attributes: [.font: UIFont.systemFont(ofSize: 12),
                         .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
}
