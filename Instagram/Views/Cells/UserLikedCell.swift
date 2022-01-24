//
//  UserLikedCell.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 18/01/2022.
//

import UIKit
import SDWebImage

class UserLikedCell: UITableViewCell {
    //MARK: Properies
    private let userAvatar: UIImageView = {
        let userAvatar = UIImageView()
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.clipsToBounds = true
        userAvatar.backgroundColor = .blue
        userAvatar.isUserInteractionEnabled = true
        return userAvatar
    }()
    
    private let userNameLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .darkText
        return label
    }()
    
    var viewModel: UserLikedCellViewModel? {
        didSet {
            configureUI()
        }
    }

    //MARK: View cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(userAvatar)
        userAvatar.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 16, constant: 1)
        userAvatar.setDimensions(height: 50, width: 50)
        userAvatar.layer.cornerRadius = 50/2
        
        addSubview(userNameLbl)
        userNameLbl.centerY(inView: userAvatar, leftAnchor: userAvatar.rightAnchor, paddingLeft: 10, constant: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    func configureUI() {
        guard let viewModel = viewModel else {return}

        userAvatar.sd_setImage(with: viewModel.profileImageUrl)
        userNameLbl.text = viewModel.userName
    }
}
