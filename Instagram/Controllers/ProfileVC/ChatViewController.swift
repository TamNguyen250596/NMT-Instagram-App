//
//  ChatViewController.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 26/01/2022.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    //MARK: Properties
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.keyboardDismissMode = .interactive
        table.separatorColor = .clear
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private lazy var commentView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccessoryView(frame: frame)
        cv.delegate = self
        return cv
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return commentView
        }
    }
    
    var receivedUser: User?
    var messageId = ""
    var messages = [Message]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var isFirstChat: Bool {
        return messages.count == 0 ? true : false
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: API
    func fetchMessages() {
        guard let receivedUser = receivedUser else {return}
        showLoader(true)
        
        MessageService.fetchMessges(withUser: receivedUser, completion: { (messages) in

            self.messages = messages
            
            let count = messages.count
            
            for index in 0..<count {
                
                let message = self.messages[index]
                
                UserService.fetchUser(withUserID: message.senderUid, completion: {
                    (user) in
                    
                    self.messages[index].senderProfile = user
                    
                })
                
            }
            
            self.showLoader(false)
            
            if !self.messages.isEmpty {
                
                let endIndex = IndexPath(row: self.messages.count - 1, section: 0)
                
                self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
            }

        })
        
    }
    
    //MARK: Actions
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Helpers
    func configureUI() {
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Feed", style: .plain,
            target: self, action: #selector(handleBack))
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 60, paddingRight: 0)
        tableView.register(SenderCell.self, forCellReuseIdentifier: CellID_Chat_Sender)
        tableView.register(ReceiverCell.self, forCellReuseIdentifier: CellID_Chat_Receiver)
        tableView.keyboardDismissMode = .interactive
    }
}

//MARK: Table view data source
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let message = messages[indexPath.row]
        
        if message.boxChatIsShouldOnRight {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID_Chat_Sender, for: indexPath) as! SenderCell
            cell.viewModel = ChatCellViewModel(message: message)
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID_Chat_Receiver, for: indexPath) as! ReceiverCell
            cell.viewModel = ChatCellViewModel(message: message)
            return cell
        }

    }
    
}

//MARK: Table view dimension
extension ChatViewController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messages[indexPath.row]
        let viewModel = ChatCellViewModel(message: message)
        let height = viewModel.dynamicCellHeigh(forWidth: view.frame.width)
        return height
    }
    
}

//MARK: CommentInputAccessoryViewDelegate
extension ChatViewController: CommentInputAccessoryViewDelegate {

    func handleEventFromPostButton(from view: CommentInputAccessoryView, withComment comment: String) {
        
        MessageService.sendMessage(with: comment, into: messageId)
        view.clearTextTyped()
    }
}


