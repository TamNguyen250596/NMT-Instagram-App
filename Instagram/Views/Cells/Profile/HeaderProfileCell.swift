//
//  HeaderProfileCell.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 08/01/2022.
//

import UIKit
import SDWebImage

protocol ProfileHeaderDelegate: AnyObject {
    func headerProfile(_profileHeader: HeaderProfileCell, didTapActionButtonFor user: User)
}

class HeaderProfileCell: UICollectionReusableView {
    //MARK: Properties
    var viewModel: HeaderProfileViewModel? {
        didSet {
          configureAvatarAndCaption()
        }
    }
    weak var delegate: ProfileHeaderDelegate?
    
    private let profileHeaderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let userNameLbl: UILabel = {
        let label = UILabel()
        label.text = "Jack Micheal"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .darkText
        return label
    }()
    
    private let numberOfPosts: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let numberOfFollowers: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let numberOfFollowing: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var editProfileBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Edit Profile", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 3
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 0.5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gridDisplayBtn: UIButton =  {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "grid"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    private lazy var listDisplayBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "list"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    private lazy var ribbonDisplayBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "ribbon"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    
    //MARK: View cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileHeaderImage)
        profileHeaderImage.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        profileHeaderImage.setDimensions(height: 80, width: 80)
        profileHeaderImage.layer.cornerRadius = 80 / 2
        
        addSubview(userNameLbl)
        userNameLbl.centerX(inView: profileHeaderImage)
        userNameLbl.anchor(top: profileHeaderImage.bottomAnchor, paddingTop: 10)
        
        
        let stackView = UIStackView(arrangedSubviews: [numberOfPosts, numberOfFollowers, numberOfFollowing])
        stackView.axis = .horizontal
        stackView.spacing = 20
        
        addSubview(stackView)
        stackView.centerY(inView: profileHeaderImage)
        stackView.anchor(left: profileHeaderImage.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12)
        
        addSubview(editProfileBtn)
        editProfileBtn.anchor(top: userNameLbl.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 10, paddingRight: 10, height: 50)
        
        let stackViewOfBtns = UIStackView(arrangedSubviews: [gridDisplayBtn, listDisplayBtn, ribbonDisplayBtn])
        stackViewOfBtns.axis = .horizontal
        stackViewOfBtns.spacing = 0
        stackViewOfBtns.distribution = .fillEqually
        
        addSubview(stackViewOfBtns)
        stackViewOfBtns.anchor(top: editProfileBtn.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Actions
    @objc func handleEditProfileFollowTapped() {
        guard let viewModel = viewModel else {return}

        delegate?.headerProfile(_profileHeader: self, didTapActionButtonFor: viewModel.user)
    }
    
    //MARK: Helpers
    func configureAvatarAndCaption(){
        guard let viewModel = viewModel else {return}
        
        userNameLbl.text = viewModel.fullName
        profileHeaderImage.sd_setImage(with: viewModel.profileImageUrl)
        
        editProfileBtn.setTitle(viewModel.followButtonText, for: .normal)
        editProfileBtn.backgroundColor = viewModel.followButtonBackground
        editProfileBtn.setTitleColor(viewModel.followBottunTextColor, for: .normal)
        
        numberOfPosts.attributedTitle(firstPart: viewModel.posts, secondPart: "POSTS")
        numberOfFollowers.attributedTitle(firstPart: viewModel.followers, secondPart: "FOLLOWERS")
        numberOfFollowing.attributedTitle(firstPart: viewModel.following, secondPart: "FOLLOWING")
    }

}
