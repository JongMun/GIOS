//
//  ToastMessage.swift
//  GIOS
//
//  Created by 정종문 on 2021/02/12.
//

import UIKit
import Foundation

extension UIView {
    func messageShow(_ controller: UIViewController, message: String?) {
        
        let alertLabel = UILabel(frame: CGRect(
                                    x: (controller.view.frame.size.width / 2) - 150,
                                    y: 150,
                                    width: 300,
                                    height: 50))
        alertLabel.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        alertLabel.textColor = UIColor.white
        alertLabel.textAlignment = .center
        alertLabel.font = UIFont(name: "", size: 13)
        alertLabel.text = message
        alertLabel.alpha = 1.0
        alertLabel.layer.cornerRadius = 10
        alertLabel.clipsToBounds = true
        
        
        controller.view.addSubview(alertLabel)
        
        UIView.animate(withDuration: 2, delay: 0.2, options: .curveEaseOut, animations: {
            alertLabel.alpha = 0
        }, completion: {
            (isCompleted) in
            alertLabel.removeFromSuperview()
        })
    }
}
