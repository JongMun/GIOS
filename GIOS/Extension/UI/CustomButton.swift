//
//  CustomButton.swift
//  GIOS
//
//  Created by 정종문 on 2021/02/11.
//

import UIKit

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

class CustomCameraButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonSetup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)!
        buttonSetup()
    }
    func buttonSetup() {
        let size:CGFloat = 40
        
        // Button Design
        self.setTitle("", for: .normal)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.widthAnchor.constraint(equalToConstant: size).isActive = true
        self.heightAnchor.constraint(equalToConstant: size).isActive = true
        self.isOpaque = true
        self.layer.opacity = 0.8
    }
}

class CustomCameraShutterButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonSetup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)!
        buttonSetup()
    }
    func buttonSetup() {
        let size:CGFloat = 80
        
        // Button Design
        self.setTitle("", for: .normal)
        self.layer.cornerRadius = size/2
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.CustomColor(name: .shutterButtonColor)?.cgColor
        self.layer.borderWidth = 2
        self.widthAnchor.constraint(equalToConstant: size).isActive = true
        self.heightAnchor.constraint(equalToConstant: size).isActive = true
        self.isOpaque = true
        self.layer.opacity = 0.8
    }
}
