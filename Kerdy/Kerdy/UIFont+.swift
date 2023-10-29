//
//  UIFont+.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 10/29/23.
//

import UIKit

extension UIFont {
    
    // MARK: - Naru Font
    
    public enum NanumSquareType: String {
        case regular = "R"
        case bold = "B"
        case extraBold = "EB"
    }
    
    static func nanumSquare(to type: NanumSquareType, size: CGFloat) -> UIFont {
        return UIFont(name: "NanumSquare"+type.rawValue, size: size)!
    }
}
