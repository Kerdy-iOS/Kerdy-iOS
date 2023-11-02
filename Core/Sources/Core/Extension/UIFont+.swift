//
//  File.swift
//  
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import UIKit

public extension UIFont {
    
    // MARK: - Naru Font
    
    enum NanumSquareType: String {
        case regular = "R"
        case bold = "B"
        case extraBold = "EB"
    }
    
    static func nanumSquare(to type: NanumSquareType, size: CGFloat) -> UIFont {
        return UIFont(name: "NanumSquare"+type.rawValue, size: size)!
    }
}
