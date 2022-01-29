//
//  ChatCell.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 26/01/2022.
//

import UIKit
import SDWebImage

class SenderCell: UITableViewCell {
    //MARK: Properties
    private let rightAvatar: UIImageView = {
        let userAvatar = UIImageView()
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.clipsToBounds = true
        userAvatar.isUserInteractionEnabled = true
        return userAvatar
    }()
    
    private let rightMessage: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let boxChatRight: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        view.layer.cornerRadius = 10
        return view
    }()
    
    var viewModel: ChatCellViewModel? {
        didSet {
            configureUI()
        }
    }
    
    //MARK: View cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(rightAvatar)
        rightAvatar.anchor(top: topAnchor, right: rightAnchor, paddingTop: 5, paddingRight: 10)
        rightAvatar.setDimensions(height: 50, width: 50)
        rightAvatar.layer.cornerRadius = 50/2
        
        addSubview(boxChatRight)
        boxChatRight.anchor(top: rightAvatar.topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAvatar.leftAnchor, paddingTop: 0, paddingLeft: 100, paddingBottom: 5, paddingRight: 10)
        boxChatRight.bottom(5)
        
        boxChatRight.addSubview(rightMessage)
        rightMessage.anchor(top: boxChatRight.topAnchor, left: boxChatRight.leftAnchor, right: boxChatRight.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingRight: 5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        guard let viewModel = viewModel else {return}
        
        rightAvatar.sd_setImage(with: viewModel.imgUrl)
        rightMessage.attributedText = viewModel.attributedTitle()
        
    }
    
}
