//
//  File.swift
//  
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import UIKit

public extension CAShapeLayer {
    
    func configureBorder(of view: UIView, withStroke strokeColor: UIColor, withFill fillColor: UIColor, using lineWidth: CGFloat) {
        
        self.path = (view.layer.mask! as! CAShapeLayer).path!
        self.strokeColor = strokeColor.cgColor
        self.fillColor = fillColor.cgColor
        self.lineWidth = lineWidth
        self.frame = view.bounds
        view.layer.addSublayer(self)
    }
}
