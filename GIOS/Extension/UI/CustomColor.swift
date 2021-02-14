//
//  Color.swift
//  GIOS
//
//  Created by 정종문 on 2021/02/11.
//

import Hue
import Foundation

enum CustomColorEnum {
    // UI Background Color
    case backgroundColor
    case buttonColor
    
    // UI Foreground Color
    case foregroundColor
    
    // UI Text Color
    case headerTextColor
    case bodyTextColor
    
    // Text in Button
    case textInButton
    
    // Camera Shuter
    case shutterButtonColor
}

extension UIColor {
    static func CustomColor(name: CustomColorEnum) -> UIColor! {
        switch name {
        case .backgroundColor:
            return UIColor(hex: "#FBF2FF")
        case .buttonColor:
            return UIColor(hex: "#A16ABD")
        case .foregroundColor:
            return UIColor(hex: "#AE72CC")
        case .headerTextColor:
            return UIColor(hex: "#696969")
        case .bodyTextColor:
            return UIColor(hex: "#474747")
        case .textInButton:
            return UIColor(hex: "#FFFFFF")
        case .shutterButtonColor:
            return UIColor.init(displayP3Red: 204/255, green: 102/255, blue: 240/255, alpha: 1)
        }
    }
}
