//
//  CustomButton.swift
//  GIOS
//
//  Created by 정종문 on 2021/02/11.
//

import UIKit
import GoogleSignIn

@IBDesignable class CustomButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            self.layer.shadowOpacity = isHighlighted ? 0 : 1
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        buttonStyle()
    }
    
    private func buttonStyle() {        
        // Color
        self.setTitleColor(UIColor.CustomColor(name: .textInButton), for: .normal)
        self.backgroundColor = UIColor.CustomColor(name: .buttonColor)
        self.tintColor = .none
        
        // Font
        self.titleLabel?.textColor = UIColor.CustomColor(name: .foregroundColor)
        self.titleLabel?.font = UIFont.CustomFont(type: .Medium, size: 20.0)
        
        // Size
        self.layer.cornerRadius = 5.0
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Shadow
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 5)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 5.0
    }
}
