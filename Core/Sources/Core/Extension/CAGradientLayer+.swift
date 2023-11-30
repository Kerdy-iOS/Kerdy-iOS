//
//  File.swift
//  
//
//  Created by JEONGEUN KIM on 11/21/23.
//

import UIKit

public extension CAGradientLayer {
    
    convenience init(topColor: UIColor, bottomColor: UIColor, view: UIView) {
        self.init()
        self.colors = [topColor.cgColor, bottomColor.cgColor]
        self.locations = [0, 1]
        self.startPoint = CGPoint(x: 0.25, y: 0.5)
        self.endPoint = CGPoint(x: 0.75, y: 0.5)
        self.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        self.bounds = view.bounds.insetBy(dx: -0.6*view.bounds.size.width,
                                          dy: -0.6*view.bounds.size.height)
        self.position = view.center
    }
}
