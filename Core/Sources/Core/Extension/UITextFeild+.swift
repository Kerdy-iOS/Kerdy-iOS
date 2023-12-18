//
//  File.swift
//
//
//  Created by JEONGEUN KIM on 12/18/23.
//

import UIKit


public extension UITextField {
    
    func setLeftPadding(amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setPlaceholder(color: UIColor, font: UIFont) {
        guard let string = self.placeholder else {
            return
        }
        attributedPlaceholder = NSAttributedString(string: string, attributes: [.foregroundColor: color, .font: font])
    }
    
    func setRightView(_ button: UIButton, width: CGFloat) {
        button.frame = CGRect(x: 0, y: 0, width: width, height: frame.size.height)
        self.rightView = button
        self.rightViewMode = .always
       }
}
