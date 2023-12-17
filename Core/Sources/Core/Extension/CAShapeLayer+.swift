//
//  File.swift
//
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import UIKit

public extension CAShapeLayer {
    func configureBorder(of view: UIView, withStroke strokeColor: UIColor, withFill fillColor: UIColor, using lineWidth: CGFloat) {
        
        self.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        self.strokeColor = strokeColor.cgColor
        self.fillColor = fillColor.cgColor
        self.lineWidth = lineWidth
        self.frame = view.bounds
    }
}
