//
//  FeedViewController.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 03/01/2022.
//

import UIKit
import Firebase

class FeedViewController: UICollectionViewController {
    //MARK: Properties
    private var posts = [Post]()
    var post: Post? {didSet {collectionView.reloadData()}}
    var isAtOneFeed: Bool {
        return (post != nil) ? true : false
    }
    var didTapLikeBtn = false
    private var currentUser: User
    
    //MARK: View cycle
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        updataFeedUserFollowed()
        observingNotificationDidTapLikeButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        if !isAtOneFeed && didTapLikeBtn {
            
            checkIfUserLiked()
            collectionView.reloadData()
        }
    }
    
    //MARK: API
    
    func updataFeedUserFollowed() {
        showLoader(true)
        
        PostService.updateUserFeedAfterFollowed(completion: { (posts) in
            self.showLoader(false)
            guard posts.count > 0 else {return}
            
            self.posts = posts
            self.checkIfUserLiked()
            self.collectionView.refreshControl?.endRefreshing()
        })
    }
    
    func checkIfUserLiked() {

        if let post = post {
            LikeService.checkIfUserLiked(forPost: post, completion: { (isLiked) in
                
                self.post?.isLiked = isLiked
            })
            
        } else {
            posts.forEach({ (post) in
                
                LikeService.checkIfUserLiked(forPost: post, completion: { (isLiked) in
                    
                    if let index = self.posts.firstIndex(where: { $0.postId == post.postId}) {
                        self.posts[index].isLiked = isLiked
                        self.collectionView.reloadData()
                    }
                })
            })
        }
    }
    
    //MARK: Helpers
    func configureUI() {
        view.backgroundColor = .white
        collectionView.register(FeedNewsCell.self, forCellWithReuseIdentifier: CellID_FeedCell)
        
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "Logout", style: .plain,
                target: self, action: #selector(handleLogout))
        }
        
        let refresher = UIRefreshControl()
        refresher.addTarget(
            self, action: #selector(handleRefresh),
            for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
    //MARK: Actions
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginVC()
            controller.delegate = self.tabBarController as? TabBarViewController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("DEBUG: Failed to signed out")
        }
    }
    
    @objc func handleRefresh() {
        updataFeedUserFollowed()
    }
    
}

//MARK: Collection View data source
extension FeedViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID_FeedCell, for: indexPath) as! FeedNewsCell
        
        cell.delegate = self
        
        if let post = post {
            cell.viewModel = FeedCellViewModel(post: post)
        } else {
            let post = posts[indexPath.row]
            cell.viewModel = FeedCellViewModel(post: post)
        }
        
        return cell
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 445)
    }
}

//MARK: FeedNewsCell delegate
extension FeedViewController: FeedNewsCellDelegate {
    
    func handleEventFromCommentButton(from cell: FeedNewsCell, with post: Post) {
        let targetVC = CommentViewController()
        targetVC.user = currentUser
        targetVC.post = post
        navigationController?.pushViewController(targetVC, animated: true)
    }
    
    func handleEventFromHeartButton(from cell: FeedNewsCell, with post: Post) {
        cell.viewModel?.post.isLiked.toggle()
        showLoader(true)
        
        if post.isLiked {
            
            LikeService.unlike(forPost: post, completion: { (error) in
                
                cell.heartBtn.setImage(cell.viewModel?.imageOfLikeBtn, for: .normal)
                cell.heartBtn.tintColor = cell.viewModel?.colorOfLikeBtn
                cell.viewModel?.post.likes = post.likes - 1
           
                NotificationCenter.default.post(
                        name: Notification_User_Did_Tap_Like_Button,
                        object: nil)
            })
            
        } else {
            
            LikeService.like(forPost: post, user: currentUser, completion: { (error) in
                cell.heartBtn.setImage(cell.viewModel?.imageOfLikeBtn, for: .normal)
                cell.heartBtn.tintColor = cell.viewModel?.colorOfLikeBtn
                cell.viewModel?.post.likes = post.likes + 1
                
                NotificationCenter.default.post(
                        name: Notification_User_Did_Tap_Like_Button,
                        object: nil)
                
                NotificationService.uploadNotification(fromCurrentUser: self.currentUser, toUser: post.ownerId, type: .like, post: post)
            })
        }
        
        showLoader(false)
    }
    
    func handleEventFromUsernameButton(from cell: FeedNewsCell, with post: Post) {
        UserService.fetchUser(withUserID: post.ownerId, completion: { (user) in
            let targetVC = ProfileViewController(user: user)
            targetVC.currentUser = self.currentUser
            self.navigationController?.pushViewController(targetVC, animated: true)
        })
    }
    
    func handleEventFromLikeLabel(from cell: FeedNewsCell, with post: Post) {
        let targetVC = UsersLikedViewController()
        targetVC.post = post
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
}

//MARK: Observes Notification_User_Did_Tap_Like_Button
extension FeedViewController {
    
    func observingNotificationDidTapLikeButton() {
        
        NotificationCenter.default.addObserver(
            forName: Notification_User_Did_Tap_Like_Button,
            object: nil, queue: OperationQueue.main,
            using: {_ in
                
                PostService.updateUserFeedAfterFollowed(completion: {
                    [unowned self] (posts) in
                    
                    self.didTapLikeBtn = true
                    self.posts = posts
                    
                    if !self.isAtOneFeed {
                        self.checkIfUserLiked()
                    }
                })
            })
    }
}

