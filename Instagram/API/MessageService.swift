//
//  ChatService.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 26/01/2022.
//

import Firebase

struct MessageService {
    
    static func createMessageID(to receiver: User, completiion: @escaping (String) -> Void) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        var key = ""
        
        Collection_User.document(currentUid).collection(User_Messages).document(receiver.uid).getDocument(completion: {
            (snapshot, error) in
            
            if let availableKey = snapshot?.data()?["messageId"] as? String {
                
                completiion(availableKey)
                
                return
                
            } else {
                
                key = Collection_User.document().documentID
            }
            
            let data: [String: Any] = ["messageId": key]
            
            Collection_User.document(currentUid).collection(User_Messages).document(receiver.uid).setData(data, completion: { (error) in
                
                Collection_User.document(receiver.uid).collection(User_Messages).document(currentUid).setData(data, completion: { (error) in
                    
                    if let error = error {
                        print("DEBUG: Failure of creating message id \(error.localizedDescription)")
                        return
                    }
                    
                    Collection_Message.document(key).collection(Message_Total).addDocument(data: [:], completion: { (error) in
                        
                        if let error = error {
                            print("DEBUG: Failure of creating message id \(error.localizedDescription)")
                            return
                        }
                        
                        Collection_Message.document(key).collection(Message_Unread).addDocument(data: [:], completion: { (error) in
                            
                            if let error = error {
                                print("DEBUG: Failure of creating message id \(error.localizedDescription)")
                                return
                            }
                            
                            completiion(key)
                            
                        })
                        
                    })
                })
            })
            
        })
        
    }
    
    static func sendMessage(with content: String, into messageID: String) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let data: [String: Any] = ["timestamp": Timestamp(date: Date()),
                                   "sender": currentUid,
                                   "content": content]
        
        Collection_Message.document(messageID).collection(Message_Total).addDocument(data: data, completion: { (error) in
            
            if let error = error {
                print("DEBUG: Failure of sending message \(error.localizedDescription)")
                return
            }
            
            Collection_Message.document(messageID).collection(Message_Unread).addDocument(data: data)
        })
        
    }
    
    static func fetchMessges(withUser user: User, completion: @escaping ([Message]) -> Void) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        var messages = [Message]()
        
        Collection_User.document(currentUid).collection(User_Messages).document(user.uid).getDocument(completion: {
            (snapshot, error) in
            
            guard let availableKey = snapshot?.data()?["messageId"] as? String else {return}
            
            Collection_Message.document(availableKey).collection(Message_Total).order(by: "timestamp", descending: false).addSnapshotListener({
                (snapshot, error) in
                
                if let error = error {
                    print("DEBUG: Failure of fetching message \(error.localizedDescription)")
                    return
                }
                
                snapshot?.documentChanges.forEach({ (change) in
                    
                    if change.type == .added {
                        
                        let data = change.document.data()
                        let message = Message(dictionary: data)
                        messages.append(message)
                    }
                })
                
                completion(messages)
            })
            
            
        })
    }
    
}

