//
//  File.swift
//
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import UIKit

public extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
    func makeCornerRound (radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func makeBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        
        let maskPath = UIBezierPath(shouldRoundRect: bounds,
                                    topLeftRadius: topLeftRadius,
                                    topRightRadius: topRightRadius,
                                    bottomLeftRadius: bottomLeftRadius,
                                    bottomRightRadius: bottomRightRadius)
        
        layer.sublayers?.filter { $0 is CAShapeLayer }.forEach { $0.removeFromSuperlayer() }
        
        let maskShape = CAShapeLayer()
        maskShape.path = maskPath.cgPath
        layer.mask = maskShape
        
        let borderShape = CAShapeLayer()
        borderShape.path = maskPath.cgPath
        borderShape.lineWidth = 2
        borderShape.strokeColor = UIColor.kerdy_main?.cgColor
        borderShape.fillColor = UIColor.clear.cgColor
        borderShape.frame = bounds
        
        layer.addSublayer(borderShape)
    }
    
    func roundCorners(
        topLeft: CGFloat = 0,
        topRight: CGFloat = 0,
        bottomLeft: CGFloat = 0,
        bottomRight: CGFloat = 0,
        borderColor: UIColor
    ) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        
        let maskPath = UIBezierPath(shouldRoundRect: bounds,
                                    topLeftRadius: topLeftRadius,
                                    topRightRadius: topRightRadius,
                                    bottomLeftRadius: bottomLeftRadius,
                                    bottomRightRadius: bottomRightRadius)
        
        layer.sublayers?.filter { $0 is CAShapeLayer }.forEach { $0.removeFromSuperlayer() }
        
        let maskShape = CAShapeLayer()
        maskShape.path = maskPath.cgPath
        layer.mask = maskShape
        
        let borderShape = CAShapeLayer()
        borderShape.path = maskPath.cgPath
        borderShape.lineWidth = 2
        borderShape.strokeColor = borderColor.cgColor
        borderShape.fillColor = UIColor.clear.cgColor
        borderShape.frame = bounds
        
        layer.addSublayer(borderShape)
    }
}
