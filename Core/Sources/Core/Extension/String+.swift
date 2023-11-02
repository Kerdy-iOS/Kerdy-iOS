//
//  File.swift
//  
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import UIKit

public extension String {
    
    func insetSize(font: UIFont ,
                   xInset: CGFloat = 50,
                   height: CGFloat = 32) -> CGSize {
        let attributes: [NSAttributedString.Key : UIFont] = [.font: font]
        let size: CGSize = self.size(withAttributes: attributes as [NSAttributedString.Key: Any])
        return CGSize(width: size.width + xInset, height: height)
    }
}
