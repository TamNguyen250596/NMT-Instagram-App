//
//  OrView.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 24/01/2022.
//

import UIKit

class OrView: UIView {
    //MARK: Properties
    private let leftLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.6)
        return view
    }()
    
    private let orLbl: UILabel = {
        let label = UILabel()
        label.text = "OR"
        label.textAlignment = .center
        label.textColor = UIColor(white: 1, alpha: 0.6)
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor(white: 1, alpha: 0.6).cgColor
        label.layer.cornerRadius = 4
        return label
    }()
    
    private let rightLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.6)
        return view
    }()
    
    //MARK: View cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(orLbl)
        orLbl.setDimensions(height: 40, width: 40)
        orLbl.centerX(inView: self)
        orLbl.centerY(inView: self)
        
        addSubview(leftLine)
        leftLine.centerY(inView: orLbl)
        leftLine.anchor(left: leftAnchor, right: orLbl.leftAnchor, paddingLeft: 20, paddingRight: 0, height: 0.5)
        
        addSubview(rightLine)
        rightLine.centerY(inView: orLbl)
        rightLine.anchor(left: orLbl.rightAnchor, right: rightAnchor, paddingLeft: 0, paddingRight: 20, height: 0.5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
