//
//  SearchViewController.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 03/01/2022.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {
    
    //MARK: Properties
    private let tableView = UITableView()
    private var users = [User]()
    private var filteredUsers = [User]()
    var posts = [Post]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearching: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        return cv
    }()
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureSearchController()
        fetchPosts()
    }
    
    //MARK: API
    func fetchUsers() {
        UserService.fetchAllUsers(completion: { (users) in
            self.users = users
            self.tableView.reloadData()
        })
    }
    
    func fetchPosts() {
        PostService.fetchAllPosts(completion: { (posts) in 
            self.posts = posts
            self.collectionView.reloadData()
        })
    }

    //MARK: Helpers
    func configureUI() {
        view.backgroundColor = .white
        title = "Explore"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: CellID_SearchCell)
        tableView.rowHeight = 64
        tableView.isHidden = true
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: CellID_ProfileCell)
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
    }
}

//MARK: Tableview datasource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredUsers.count : users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID_SearchCell, for: indexPath) as! UserCell
        let user = isSearching ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.viewModel = UserCellViewModel(user: user)
        return cell
    }
}

//MARK: Table view delegate
extension SearchViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = isSearching ? filteredUsers[indexPath.row] : users[indexPath.row]
        let targetVC = ProfileViewController(user: user)
        navigationController?.pushViewController(targetVC, animated: true)
    }
}

//MARK: SearchController
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        
        filteredUsers = users.filter({
            $0.userName.lowercased().contains(searchText) ||
            $0.fullName.lowercased().contains(searchText)
        })
        
        tableView.reloadData()
    }
}

//MARK: SearchBar delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        collectionView.isHidden = true
        tableView.isHidden = false
        fetchUsers()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        
        collectionView.isHidden = false
        tableView.isHidden = true
        fetchPosts()
    }
    
}

//MARK: CollectionView data sources
extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID_ProfileCell, for: indexPath) as! ProfileCell

        let post = posts[indexPath.row]
        cell.viewModel = ProfileCellViewModel(post: post)
        
        return cell
    }
}

//MARK: Collection view delegate
extension SearchViewController: UICollectionViewDelegate {
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let tab = self.tabBarController as? TabBarViewController else {return}
        guard let user = tab.user else {return}
         
        let post = posts[indexPath.row]
        let controller = FeedViewController(currentUser: user)
        controller.post = post
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: UICollection layout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
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
    
}



