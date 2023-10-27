//
//  UIFont+.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 2023/10/27.
//

import UIKit

extension UIFont {
    
    // MARK: - Naru Font
    
    public enum NanumSquareType: String {
        case regular = "R"
        case bold = "B"
        case extraBold = "EB"
    }
    
    static func nanumSqure(to type: NanumSquareType, size: CGFloat) -> UIFont {
        return UIFont(name: "NanumSquare_ac"+type.rawValue, size: size)!
    }
}
