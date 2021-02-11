//
//  CustomTextField.swift
//  GIOS
//
//  Created by 정종문 on 2021/02/11.
//

import UIKit

@IBDesignable class CustomTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        textFieldStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textFieldStyle()
    }
    
    private func textFieldStyle() {        
        // Color
        self.layer.borderColor = UIColor.CustomColor(name: .backgroundColor)?.cgColor
        
        // Font
        self.font = UIFont.CustomFont(type: .Medium, size: 17)
        
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
