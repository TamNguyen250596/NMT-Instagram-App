//
//  GradientColor.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 05/01/2022.
//

import UIKit

@IBDesignable
class GradientColor: UIView {
    
    @IBInspectable var topColor: UIColor = UIColor.systemPurple {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = UIColor.systemBlue {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
        
}
