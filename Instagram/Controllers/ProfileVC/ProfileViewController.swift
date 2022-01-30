//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 03/01/2022.
//

import UIKit
import Firebase

class ProfileViewController: UICollectionViewController {
    //MARK: Properties
    private var posts = [Post]()
    private var user: User
        
    //MARK: View cycle
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        checkIsUserFollowed()
        fetchUserStats()
        fetchPosts()
    }
    
    //MARK: API
    func checkIsUserFollowed() {
        UserService.checkIfUserIsFollowed(uid: user.uid, completion: { (isFollowd) in
            self.user.isFollowed = isFollowd
            self.collectionView.reloadData()
        })
    }
    
    func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid, completion: { (userStats) in
            self.user.userStats = userStats
            self.collectionView.reloadData()
        })
    }
    
    func fetchPosts() {
        PostService.fetchPosts(forUser: user.uid, completion: { (posts) in
            self.posts = posts
            self.collectionView.reloadData()
        })
    }
    
    //MARK: Helpers
    func configureCollectionView() {
        navigationItem.title = user.userName 
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: CellID_ProfileCell)
        collectionView.register(HeaderProfileCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellID_Header_ProfileCell)
    }
}

//MARK: UICollection data source
extension ProfileViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID_ProfileCell, for: indexPath) as! ProfileCell
        
        let post = posts[indexPath.row]
        cell.viewModel = ProfileCellViewModel(post: post)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellID_Header_ProfileCell, for: indexPath) as! HeaderProfileCell
            
            
            header.viewModel = HeaderProfileViewModel(user: user)
            header.delegate = self

        return header
    }
}

//MARK: Collection view delegate
extension ProfileViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let controller = FeedViewController(currentUser: user)
        controller.post = post
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: UICollection layout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}

//MARK: ProfileHeaderDelegate
extension ProfileViewController: ProfileHeaderDelegate {
    
    func headerProfile(_profileHeader: HeaderProfileCell, didTapActionButtonFor user: User) {
        guard let tabVC = self.tabBarController as? TabBarViewController else {return}
        guard let currentUser = tabVC.user else {return}
        
        if user.isCurrentUser {
            print("DEBUG: Profile of the current account")
            
        } else if user.isFollowed {
            UserService.unfollow(uid: user.uid, completion: { (error) in
                self.user.isFollowed = false
                self.fetchUserStats()
                self.collectionView.reloadData()
                
                PostService.compilePostID(uid: user.uid, didFollow: false)
            })
            
        } else {
            UserService.follow(uid: user.uid, completion: { (error) in
                self.user.isFollowed = true
                self.fetchUserStats()
                self.collectionView.reloadData()
                
                NotificationService.uploadNotification(fromCurrentUser: currentUser, toUser: user.uid, type: .follow)
                
                PostService.compilePostID(uid: user.uid, didFollow: true)
            })
        }
    }
    
    func handleEventFromChatButton(_profileHeader: HeaderProfileCell, didTapActionButtonFor user: User) {
        showLoader(true)
        
        MessageService.createMessageID(to: user, completion: { (key) in
            
            let targetVC = ChatViewController()
            targetVC.receivedUser = user
            targetVC.messageId = key
            self.navigationController?.pushViewController(targetVC, animated: true)
            
        })
        showLoader(false)
    }
}
