//
//  FeedNewsCell.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 04/01/2022.
//

import UIKit
import SDWebImage

protocol FeedNewsCellDelegate: AnyObject {
    func handleEventFromCommentButton(from cell: FeedNewsCell, with post: Post)
    func handleEventFromHeartButton(from cell: FeedNewsCell, with post: Post)
    func handleEventFromUsernameButton(from cell: FeedNewsCell, with post: Post)
    func handleEventFromLikeLabel(from cell: FeedNewsCell, with post: Post)
}

class FeedNewsCell: UICollectionViewCell {
    //MARK: Properties
    private let userAvatar: UIImageView = {
        let userAvatar = UIImageView()
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.clipsToBounds = true
        userAvatar.backgroundColor = .lightGray
        userAvatar.isUserInteractionEnabled = true
        return userAvatar
    }()
    
    private lazy var userNameBtn: UIButton = {
        let userNameBtn = UIButton()
        userNameBtn.setTitleColor(.black, for: .normal)
        userNameBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        userNameBtn.addTarget(self, action: #selector(didTapUsername), for: .touchUpInside)
        return userNameBtn
    }()
    
    private lazy var optionBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    private let postedImg: UIImageView = {
        let postedImg = UIImageView()
        postedImg.contentMode = .scaleAspectFill
        postedImg.clipsToBounds = true
        postedImg.backgroundColor = .lightGray
        postedImg.isUserInteractionEnabled = true
        return postedImg
    }()
    
    lazy var heartBtn: UIButton =  {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(handleTapHeartButton), for: .touchUpInside)
        return btn
    }()
    
    private lazy var commentBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "comment"), for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(handleTapComment), for: .touchUpInside)
        return btn
    }()
    
    private lazy var shareBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "send2"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    private lazy var pinBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "ribbon"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    lazy var numberOfLikesLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapLikeLbl))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        
        return label
    }()
    
    private let captionLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let postedTime: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    var viewModel: FeedCellViewModel? {
        didSet {
         configureUI()
        }
    }
    
    weak var delegate: FeedNewsCellDelegate?
    
    //MARK: View cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(userAvatar)
        userAvatar.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 16)
        userAvatar.setDimensions(height: 40, width: 40)
        userAvatar.layer.cornerRadius = 40/2
        
        self.addSubview(userNameBtn)
        userNameBtn.centerY(inView: userAvatar, leftAnchor: userAvatar.rightAnchor, paddingLeft: 8)
        
        self.addSubview(optionBtn)
        optionBtn.centerY(inView: userNameBtn)
        optionBtn.anchor(right: rightAnchor, paddingRight: 16)
        
        self.addSubview(postedImg)
        postedImg.anchor(top: userAvatar.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0)
        postedImg.setDimensions(height: 250, width: self.frame.width)
        
        let stackView = UIStackView(arrangedSubviews: [heartBtn, commentBtn, shareBtn])
        self.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.anchor(top: postedImg.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 16)
        stackView.setDimensions(height: 50, width: 100)
        
        self.addSubview(pinBtn)
        pinBtn.anchor(top: postedImg.bottomAnchor, right: rightAnchor, paddingTop: 10, paddingRight: 16)
        
        self.addSubview(numberOfLikesLbl)
        numberOfLikesLbl.anchor(top: stackView.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 16)
        
        self.addSubview(captionLbl)
        captionLbl.anchor(top: numberOfLikesLbl.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 16)
        
        self.addSubview(postedTime)
        postedTime.anchor(top: captionLbl.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Actions
    @objc func didTapUsername() {
        guard let viewModel = viewModel else {return}
        
        delegate?.handleEventFromUsernameButton(from: self, with: viewModel.post)
    }
    
    @objc func handleTapComment() {
        guard let viewModel = viewModel else {return}

        delegate?.handleEventFromCommentButton(from: self, with: viewModel.post)
    }
    
    @objc func handleTapHeartButton() {
        guard let viewModel = viewModel else {return}
        
        delegate?.handleEventFromHeartButton(from: self, with: viewModel.post)
    }
    
    @objc func handleTapLikeLbl(sender: UITapGestureRecognizer) {
        guard let viewModel = viewModel else {return}
        
        delegate?.handleEventFromLikeLabel(from: self, with: viewModel.post)
    }
    
    //MARK: Helpers
    func configureUI() {
        guard let viewModel = viewModel else {return}
        
        userAvatar.sd_setImage(with: viewModel.ownerImgUrl)
        postedImg.sd_setImage(with: viewModel.imageUrl)
        userNameBtn.setTitle(viewModel.ownerUserName, for: .normal)
        numberOfLikesLbl.text = viewModel.likes
        captionLbl.text = viewModel.caption
        heartBtn.tintColor = viewModel.colorOfLikeBtn
        heartBtn.setImage(viewModel.imageOfLikeBtn, for: .normal)
        postedTime.text = viewModel.timestampString
    }
}
