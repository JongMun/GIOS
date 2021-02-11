//
//  Font.swift
//  GIOS
//
//  Created by 정종문 on 2021/02/11.
//

import UIKit
import Foundation

enum CustomFontEnum {
    case Bold
    case Medium
    case Regular
}

extension UIFont {
    static func CustomFont(type: CustomFontEnum, size: CGFloat) -> UIFont! {
        switch type {
        case .Bold:
            guard let font = UIFont(name: "Wemakeprice-Bold", size: size) else {
                return nil
            }
            return font
        case .Medium:
            guard let font = UIFont(name: "Wemakeprice-SemiBold", size: size) else {
                return nil
            }
            return font
        case .Regular:
            guard let font = UIFont(name: "Wemakeprice-Regular", size: size) else {
                return nil
            }
            return font
        }
    }
}
