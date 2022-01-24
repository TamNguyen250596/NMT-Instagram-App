//
//  ProfileCell.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 08/01/2022.
//

import UIKit
import SDWebImage

class ProfileCell: UICollectionViewCell {
    //MARK: Properties
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .orange
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var viewModel: ProfileCellViewModel? {
        didSet {
            configueUI()
        }
    }
    
    //MARK: View cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImage)
        profileImage.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    func configueUI() {
        profileImage.sd_setImage(with: viewModel?.imageUrl)
    }
        
}
