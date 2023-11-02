//
//  File.swift
//  
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import UIKit

public extension UILabel {
    
    /// 행간 조정 메서드
    func setLineSpacing(lineSpacing: CGFloat) {
        if let text = self.text {
            let attributedStr = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            attributedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedStr.length))
            self.attributedText = attributedStr
        }
    }
}
