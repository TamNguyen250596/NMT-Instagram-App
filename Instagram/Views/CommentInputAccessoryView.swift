//
//  CommentInputAccessoryView.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 14/01/2022.
//

import UIKit

protocol CommentInputAccessoryViewDelegate: AnyObject {
    func handleEventFromPostButton(from view: CommentInputAccessoryView, withComment comment: String)
}

class CommentInputAccessoryView: UIView {
    //MARK: Properties
    private let commentView: CustomTextView = {
        let textView = CustomTextView()
        textView.placeholder = "Enter comment ... "
        textView.textColor = .darkText
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = true
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 16
        textView.positionShouldCenter = true
        return textView
    }()
    
    private let postBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("POST", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.darkText, for: .normal)
        btn.addTarget(self, action: #selector(handleTapPost), for: .touchUpInside)
        return btn
    }()
    
    weak var delegate: CommentInputAccessoryViewDelegate?
    
    //MARK: View cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        
        addSubview(postBtn)
        postBtn.anchor(right: rightAnchor, paddingRight: 0)
        postBtn.setDimensions(height: 50, width: 50)
        
        addSubview(commentView)
        commentView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: postBtn.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 0.25)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Actions
    @objc func handleTapPost() {
        
        delegate?.handleEventFromPostButton(from: self, withComment: commentView.text)
    }
    
    func clearTextTyped() {
        commentView.text.removeAll()
        commentView.placeholderLbl.isHidden = false
    }
}


