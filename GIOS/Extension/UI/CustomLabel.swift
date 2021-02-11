//
//  CustomLabel.swift
//  GIOS
//
//  Created by 정종문 on 2021/02/11.
//

import UIKit

@IBDesignable class CustomBoldLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        labelStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        labelStyle()
    }
    
    private func labelStyle() {
        // Color
        self.backgroundColor = .none
        self.textColor = UIColor.CustomColor(name: .headerTextColor)
        
        // Font
        self.font = UIFont.CustomFont(type: .Bold, size: 30)
        self.textAlignment = .center
        
        // Size
        self.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        // Shadow
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 5)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 5.0
    }
}
