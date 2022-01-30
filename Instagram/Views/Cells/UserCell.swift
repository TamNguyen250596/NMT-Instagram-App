//
//  UserCell.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 10/01/2022.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    //MARK: Properties
    var viewModel: UserCellViewModel? {
        didSet {
            configureAvatarAndNames()
        }
    }
    
    private let userAvatar: UIImageView = {
        let userAvatar = UIImageView()
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.clipsToBounds = true
        userAvatar.backgroundColor = .lightGray
        userAvatar.isUserInteractionEnabled = true
        return userAvatar
    }()
    
    private let userNameLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .darkText
        return label
    }()
    
    private let fullNameLbl: UILabel = {
        let label = UILabel()
        label.text = "Jonny Black Gei"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: View cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: CellID_SearchCell)
        
        addSubview(userAvatar)
        userAvatar.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 16, constant: 1)
        userAvatar.setDimensions(height: 50, width: 50)
        userAvatar.layer.cornerRadius = 50/2
        
        let stackView = UIStackView(arrangedSubviews: [userNameLbl, fullNameLbl])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        
        addSubview(stackView)
        stackView.centerY(inView: userAvatar)
        stackView.anchor(left: userAvatar.rightAnchor, paddingLeft: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    func configureAvatarAndNames(){
        guard let viewModel = viewModel else {return}
        
        userNameLbl.text = viewModel.userName
        fullNameLbl.text = viewModel.fullName
        userAvatar.sd_setImage(with: viewModel.profileImageUrl)
    }
}
