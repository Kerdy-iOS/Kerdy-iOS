//
//  File.swift
//  
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import UIKit

public extension CALayer {
    
    func applyShadow(
        color: UIColor? = .black,
        alpha: Float = 0.1,
        x: CGFloat = 0,
        y: CGFloat = 1,
        blur: CGFloat = 6
    ) {
        shadowColor = color?.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}
