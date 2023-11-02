//
//  File.swift
//  
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import UIKit

public extension UISwitch {
    
    func setSize(width: CGFloat, height: CGFloat) {
        
        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51
        
        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth
        
        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}
