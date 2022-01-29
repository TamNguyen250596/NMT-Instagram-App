//
//  ReceiverCell.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 27/01/2022.
//

import UIKit
import SDWebImage

class ReceiverCell: UITableViewCell {
    //MARK: Properties
    private let leftAvatar: UIImageView = {
        let userAvatar = UIImageView()
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.clipsToBounds = true
        userAvatar.isUserInteractionEnabled = true
        return userAvatar
    }()
    
    private let leftMessage: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let boxChatLeft: UIView = {
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
        
        addSubview(leftAvatar)
        leftAvatar.anchor(top: topAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 10)
        leftAvatar.setDimensions(height: 50, width: 50)
        leftAvatar.layer.cornerRadius = 50/2
        
        addSubview(boxChatLeft)
        boxChatLeft.anchor(top: leftAvatar.topAnchor, left: leftAvatar.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 5, paddingRight: 100)
        boxChatLeft.bottom(5)
        
        boxChatLeft.addSubview(leftMessage)
        leftMessage.anchor(top: boxChatLeft.topAnchor, left: boxChatLeft.leftAnchor, right:  boxChatLeft.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingRight: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    func configureUI() {
        guard let viewModel = viewModel else {return}
        
        leftAvatar.sd_setImage(with: viewModel.imgUrl)
        leftMessage.attributedText = viewModel.attributedTitle()
        
    }
}
