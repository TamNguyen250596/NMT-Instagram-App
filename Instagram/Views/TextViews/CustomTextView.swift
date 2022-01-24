//
//  CustomTextView.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 12/01/2022.
//

import UIKit


class CustomTextView: UITextView {
    //MARK: Properties
    var placeholder: String? {
        didSet {
            placeholderLbl.text = placeholder
        }
    }
    
    var positionShouldCenter = true {
        didSet {
            if positionShouldCenter {
                placeholderLbl.centerY(
                    inView: self, leftAnchor: leftAnchor,
                    paddingLeft: 10, constant: 1)
            } else {
                placeholderLbl.anchor(
                    top: topAnchor, left: leftAnchor,
                    paddingTop: 5, paddingLeft: 5)
            }
        }
    }
    
    let placeholderLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    

    //MARK: View cycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: nil)
        
        addSubview(placeholderLbl)
        bringSubviewToFront(placeholderLbl)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(textDidChangeHandler),
            name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Actions
    @objc func textDidChangeHandler() {
        if text.isEmpty {
            placeholderLbl.isHidden = false
        } else {
            placeholderLbl.isHidden = true
            delegate?.textViewDidBeginEditing?(self)
        }
    }
}
