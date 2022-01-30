//
//  NotificationCell.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 18/01/2022.
//

import UIKit
import SDWebImage

protocol NotificationCellDelegate: AnyObject {
    func handleEventFromFollowButton(cell: NotificationCell, wantsToFollow uid: String)
    func handleEventFromFollowButton(cell: NotificationCell, wantsToUnFollow uid: String)
    func handleEventFromPostImage(cell: NotificationCell, wantsToShowPost postId: String)
}

class NotificationCell: UITableViewCell {
    //MARK: Properteis
    private let userAvatar: UIImageView = {
        let userAvatar = UIImageView()
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.clipsToBounds = true
        userAvatar.backgroundColor = .blue
        userAvatar.isUserInteractionEnabled = true
        userAvatar.backgroundColor = .lightGray
        return userAvatar
    }()
    
    private let infoLbl: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let notificationDate: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var postImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapPost(sender:)))
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(tap)
        
        return img
    }()
    
    lazy var followBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 0.5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        btn.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
        return btn
    }()
    
    var viewModel: NotificationCellViewModel? {
        didSet {
            configureUI()
        }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    //MARK: View cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addSubview(userAvatar)
        userAvatar.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 16, constant: 1)
        userAvatar.setDimensions(height: 50, width: 50)
        userAvatar.layer.cornerRadius = 50/2
        
        let stackView = UIStackView(arrangedSubviews: [infoLbl, notificationDate])
        stackView.axis = .vertical
        stackView.spacing = 10
        
        contentView.addSubview(stackView)
        stackView.centerY(inView: userAvatar, leftAnchor: userAvatar.rightAnchor, paddingLeft: 10, constant: 1)
        stackView.anchor(right: rightAnchor, paddingRight: 70)
        
        contentView.addSubview(followBtn)
        followBtn.centerY(inView: self)
        followBtn.anchor(right: rightAnchor, paddingRight: 12, width: 60, height: 32)
        
        contentView.addSubview(postImageView)
        postImageView.centerY(inView: self)
        postImageView.anchor(right: rightAnchor, paddingRight: 12, width: 50, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Actions
    @objc func handleEditProfileFollowTapped() {
        guard let viewModel = viewModel else {return}
        
        if viewModel.notification.isFollowed {
            delegate?.handleEventFromFollowButton(cell: self, wantsToUnFollow: viewModel.notification.uid)
        } else {
            delegate?.handleEventFromFollowButton(cell: self, wantsToFollow: viewModel.notification.uid)
        }
    }
    
    @objc func handleTapPost(sender: UIImageView) {
        print("handleEventFromPostImage called before unwarp")
        guard let viewModel = viewModel else {return}
        print("handleEventFromPostImage called after unwarp")
        delegate?.handleEventFromPostImage(cell: self, wantsToShowPost: viewModel.notification.postId)
    }
    
    //MARK: Helpers
    func configureUI() {
        guard let viewModel = viewModel else {return}
        
        userAvatar.sd_setImage(with: viewModel.profileImgUrl)
        infoLbl.attributedText = viewModel.infoTxt
        notificationDate.attributedText = viewModel.timestampString
        postImageView.sd_setImage(with: viewModel.postImgUrl)
        postImageView.isHidden = viewModel.postImgIsShouldHide
        followBtn.isHidden = !viewModel.postImgIsShouldHide
        followBtn.setTitle(viewModel.isFollowed, for: .normal)
        followBtn.backgroundColor = viewModel.backgroundColor
        followBtn.setTitleColor(viewModel.tintColor, for: .normal)
    }
}
