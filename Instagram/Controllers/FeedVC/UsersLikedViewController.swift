//
//  UsersLikedViewController.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 18/01/2022.
//

import UIKit

class UsersLikedViewController: UITableViewController {
    //MARK: Properties
    var post: Post?
    private var liked = [Liked]()
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUsersLiked()
    }
    
    //MARK: API
    func fetchUsersLiked() {
        guard let post = post else {return}
        
        LikeService.fetchUsersLiked(forPost: post, completion: { (liked) in
            
            self.liked = liked
            self.tableView.reloadData()
        })
    }
    
    //MARK: Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        tableView.register(UserLikedCell.self, forCellReuseIdentifier: CellID_UserLiked)
        tableView.rowHeight = 66
    }

}

// MARK: - Table view data source
extension UsersLikedViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liked.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID_UserLiked, for: indexPath) as! UserLikedCell
        let liked = liked[indexPath.row]
        cell.viewModel = UserLikedCellViewModel(liked: liked)
        return cell
    }
}

//MARK: table view delegate
extension UsersLikedViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userId = liked[indexPath.row].uid
        tableView.deselectRow(at: indexPath, animated: true)
        
        UserService.fetchUser(withUserID: userId, completion: { (user) in
            
            let targetVC = ProfileViewController(user: user)
            self.navigationController?.pushViewController(targetVC, animated: true)
        })
    }
}
