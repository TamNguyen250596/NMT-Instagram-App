//
//  Constants.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 04/01/2022.
//

import Firebase

//MARK: typealias of closures
typealias CompletionHandlerStringToVoid = (String) -> Void
typealias CompletionHandlerOptionalErrorToVoid = (Error?) -> Void
typealias CompletionHandlerBoolToVoid = (Bool) -> Void

//MARK: Cell ID
let CellID_FeedCell = "cellIdOfFeedCell"
let CellID_ProfileCell = "cellIdOfProfileCell"
let CellID_Header_ProfileCell = "cellIdOfHeaderProfileCell"
let CellID_SearchCell = "cellIdOfSearchCell"
let CellID_CommentCell = "cellIdOfCommentCell"
let CellID_NotificationCell = "cellIdOfNotificationCell"
let CellID_UserLiked = "cellIdOfUsersLiked"
let CellID_Chat_Sender = "cellIdOfChatSenderCell"
let CellID_Chat_Receiver = "cellIdOfChatReceiverCell"

//MARK: Collection ID
let Collection_User = Firestore.firestore().collection("users")
let Collection_Followers = Firestore.firestore().collection("followers")
let Collection_Following = Firestore.firestore().collection("following")
let Collection_Post = Firestore.firestore().collection("posts")
let Collection_Notification = Firestore.firestore().collection("notifications")
let Collection_Message = Firestore.firestore().collection("messages-private")

let User_Followers = "user-followers"
let User_Following = "user-following"
let User_Likes = "user-likes"
let User_Feeds = "user-feeds"
let User_Notifications = "user-notifications"
let User_Messages = "user-messages"
let Post_Likes = "post-likes"
let Post_Comments = "post-comments"
let Message_Total = "message-total"
let Message_Unread = "message-unread"
let Message_Sent = "message-sent"

//MARK: Notification name
let Notification_User_Did_Tap_Like_Button = NSNotification.Name("notificationOfUserDidTapLikeButton")




