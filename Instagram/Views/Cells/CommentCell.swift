//
//  CommentCell.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 14/01/2022.
//

import UIKit
import SDWebImage

class CommentCell: UITableViewCell {
    //MARK: Properties
    private let userAvatar: UIImageView = {
        let userAvatar = UIImageView()
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.clipsToBounds = true
        userAvatar.backgroundColor = .blue
        userAvatar.isUserInteractionEnabled = true
        return userAvatar
    }()
    
    private let commentLbl: UILabel = {
        let label = UILabel()
        label.text = "The first comment today"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var viewModel: CommentCellViewModel? {
        didSet {
            configureUI()
        }
    }
    
    //MARK: View cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: CellID_CommentCell)
        
        addSubview(userAvatar)
        userAvatar.anchor(top: topAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 10)
        userAvatar.setDimensions(height: 50, width: 50)
        userAvatar.layer.cornerRadius = 50/2
        
        let boxChat = UIView()
        boxChat.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        boxChat.layer.cornerRadius = 10
        
        addSubview(boxChat)
        boxChat.anchor(top: userAvatar.topAnchor, left: userAvatar.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 5, paddingRight: 10)
        boxChat.bottom(5)
        
        boxChat.addSubview(commentLbl)
        commentLbl.anchor(top: boxChat.topAnchor, left: boxChat.leftAnchor, right:  boxChat.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingRight: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    func configureUI() {
        guard let viewModel = viewModel else {return}
        
        commentLbl.attributedText = viewModel.attributedTitle()
        userAvatar.sd_setImage(with: viewModel.avatarImg)
    }
}
