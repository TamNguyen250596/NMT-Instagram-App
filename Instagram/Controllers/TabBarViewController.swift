//
//  TabBarViewController.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 03/01/2022.
//

import UIKit
import Firebase
import YPImagePicker

class TabBarViewController: UITabBarController {
    //MARK: Properties
    var user: User? {
        didSet {
            guard let user = user else {return}
            includeTabSections(withUser: user)
        }
    }
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser()
        checkIfUserLogined()
        logout()
        view.backgroundColor = .white
    }
    
    //MARK: API
    func checkIfUserLogined() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginVC()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.fetchUser(withUserID: uid) { (user) in
            
            self.user = user
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Failed to signed out")
        }
    }
    
    //MARK: Helper functions
    func createTabSection(targetVC: UIViewController, titleTabbar:String, imageTabbar: String) -> UINavigationController {
        let targetVC = UINavigationController(rootViewController: targetVC)
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ]
        targetVC.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        targetVC.tabBarItem.title = titleTabbar
        
        tabBar.tintColor = .black
        
        targetVC.tabBarItem.image = UIImage(named: imageTabbar + "_unselected")
        targetVC.tabBarItem.selectedImage = UIImage(named: imageTabbar + "_selected")
        
        return targetVC
    }
    
    func includeTabSections(withUser user: User) {
        self.delegate = self
        let feedVC = FeedViewController(currentUser: user)
        let targetOne = createTabSection(targetVC: feedVC, titleTabbar: "Feed", imageTabbar: "home")
        
        let targetTwo = createTabSection(targetVC: SearchViewController(), titleTabbar: "Search", imageTabbar: "search")
        
        let targetThree = createTabSection(targetVC: ImagePickerViewController(), titleTabbar: "Image", imageTabbar: "plus")
        
        let targetFour = createTabSection(targetVC: NotificationViewController(), titleTabbar: "Notification", imageTabbar: "like")
        
        let profileVC = ProfileViewController(user: user)
        let targetFive = createTabSection(targetVC: profileVC, titleTabbar: "Profile", imageTabbar: "profile")
        
        viewControllers = [targetOne, targetTwo, targetThree, targetFour, targetFive]
    }
    
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking(completion: { (items, _) in
            picker.dismiss(animated: true, completion: nil)
            guard let selectedImage = items.singlePhoto?.image else {return}
            
            let targetVC = UploadPostController()
            let nav = UINavigationController(rootViewController: targetVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
            
            targetVC.imageDidChoose = selectedImage
            targetVC.delegate = self
            targetVC.user = self.user
        })
    }
}

//MARK: AuthenticationDelegate
extension TabBarViewController: AuthenticationDelegate {
    func anuthenticalDidComplete() {
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: TabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            
            didFinishPickingMedia(picker)
        }
        
        return true
    }
}

//MARK: UploadPostVC delegate
extension TabBarViewController: UploadPostDelegate {
    func dismissAnOpenVC() {
        self.dismiss(animated: true, completion: nil)
        self.selectedIndex = 0
        
        guard let feedInNav = viewControllers?.first as? UINavigationController else {return}
        guard let feedVC = feedInNav.viewControllers.first as? FeedViewController else {return}
        feedVC.handleRefresh()
    }
}
