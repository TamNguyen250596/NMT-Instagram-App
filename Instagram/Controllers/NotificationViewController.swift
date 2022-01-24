//
//  NotificationViewController.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 03/01/2022.
//

import Firebase

class NotificationViewController: UITableViewController {
    //MARK: Properties
    private var notifications = [Notification]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private let refresher = UIRefreshControl()
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchNotifications()
    }
    
    //MARK: API
    func fetchNotifications() {
        NotificationService.fetchNotifications(completion: { (notifications) in
            self.notifications = notifications
            self.checkIfUsersFollowed()
        })
    }
    
    func checkIfUsersFollowed() {
        notifications.forEach({ (notification) in
            guard notification.type == .follow else {return}
            
            UserService.checkIfUserIsFollowed(uid: notification.uid, completion: { (isFollowed) in
                
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id}) {
                    self.notifications[index].isFollowed = isFollowed
                }
            })
        })
    }
    
    //MARK: Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        title = "Notification"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: CellID_NotificationCell)
        tableView.rowHeight = 60
        tableView.separatorColor = .clear
        tableView.refreshControl = refresher
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    //MARK: Actions
    @objc func handleRefresh() {
        notifications.removeAll()
        fetchNotifications()
        refresher.endRefreshing()
    }
}

extension NotificationViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID_NotificationCell, for: indexPath) as! NotificationCell
        
        let notification = notifications[indexPath.row]
        cell.viewModel = NotificationCellViewModel(notification: notification)
        cell.delegate = self
        return cell
    }
}

extension NotificationViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userId = notifications[indexPath.row].uid
        showLoader(true)
        
        UserService.fetchUser(withUserID: userId, completion: { (user) in
            self.showLoader(false)
            
            let targetVC = ProfileViewController(user: user)
            self.navigationController?.pushViewController(targetVC, animated: true)
        })
    }
}

extension NotificationViewController: NotificationCellDelegate {
    
    func handleEventFromFollowButton(cell: NotificationCell, wantsToFollow uid: String) {
        showLoader(true)
        
        UserService.follow(uid: uid, completion: {_ in
            
            self.showLoader(false)
            
            cell.viewModel?.notification.isFollowed.toggle()
        })
    }
    
    func handleEventFromFollowButton(cell: NotificationCell, wantsToUnFollow uid: String) {
        showLoader(true)
        
        UserService.unfollow(uid: uid, completion: {_ in
            
            self.showLoader(false)
            
            cell.viewModel?.notification.isFollowed.toggle()
        })
        
    }
    
    func handleEventFromPostImage(cell: NotificationCell, wantsToShowPost postId: String) {
        
        guard let currentId = Auth.auth().currentUser?.uid else {return}
        guard let tab = self.tabBarController as? TabBarViewController else {return}
        guard let user = tab.user else {return}
        showLoader(true)
        
        PostService.fetchPosts(forUser: currentId, completion: { (posts) in
            
            self.showLoader(false)
            
            let post = posts.first(where: {$0.postId == postId})
            let targetVC = FeedViewController(currentUser: user)
            targetVC.post = post
            self.navigationController?.pushViewController(targetVC, animated: true)
        })
    }
}
