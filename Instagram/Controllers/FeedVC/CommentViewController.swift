//
//  CommentViewController.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 14/01/2022.
//

import UIKit

class CommentViewController: UIViewController {
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
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    var user: User?
    var post: Post?
    private var comments = [Comment]()
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchComments()
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
    func fetchComments() {
        guard let post = post else {return}

        CommentService.fetchComments(forPost: post.postId, completion: { (comments) in
            self.comments = comments
            self.tableView.reloadData()
            
            if !self.comments.isEmpty {
                
                let endIndex = IndexPath(row: self.comments.count - 1, section: 0)
                
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
        tableView.register(CommentCell.self, forCellReuseIdentifier: CellID_CommentCell)
        tableView.keyboardDismissMode = .interactive
    
    }
}

// MARK: - Table view data source
extension CommentViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID_CommentCell, for: indexPath) as! CommentCell
        
        let comment = comments[indexPath.row]
        cell.viewModel = CommentCellViewModel(comment: comment)
        
        return cell
    }
}

//MARK: Table view delegate
extension CommentViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uid = comments[indexPath.row].uid
        UserService.fetchUser(withUserID: uid, completion: { (user) in
            
            let targetVC = ProfileViewController(user: user)
            self.navigationController?.pushViewController(targetVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        })
    }
}

//MARK: Table view diemnsion
extension CommentViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let comment = comments[indexPath.row]
        let viewModel = CommentCellViewModel(comment: comment)
        let height = viewModel.dynamicCellHeight(forWidth: view.frame.width)
        return height
    }
}

//MARK: CommentInputAccessoryViewDelegate
extension CommentViewController: CommentInputAccessoryViewDelegate {

    func handleEventFromPostButton(from view: CommentInputAccessoryView, withComment comment: String) {
        guard let post = post else {return}
        guard let user = user else {return}
        
        CommentService.postComment(
            postID: post.postId, user: user, comment: comment,
            completion: { (error) in
                
                if let error = error {
                    print("DEBUG: Error of upload comments \(error.localizedDescription)")
                    return
                }
                view.resetTextView()
                
                NotificationService.uploadNotification(fromCurrentUser: user, toUser: post.ownerId, type: .comment, post: post)
            })
    }
}

