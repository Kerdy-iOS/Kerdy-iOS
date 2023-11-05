//
//  File.swift
//
//
//  Created by 이동현 on 11/2/23.
//

import UIKit

public class ProtrudingBtn: UIButton {
    
    public init(
        frame: CGRect,
        title: String,
        titleColor: UIColor,
        backgroundColor: UIColor,
        topLeft: CGFloat,
        topRight: CGFloat,
        bottomLeft: CGFloat,
        bottomRight: CGFloat
    ) {
        super.init(frame: frame)
   
        setUI(title: title,
              titleColor: titleColor,
              backgroundColor: backgroundColor,
              topLeft: topLeft,
              topRight: topRight,
              bottomLeft: bottomLeft,
              bottomRight: bottomRight
        )
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setUI(
        title: String,
        titleColor: UIColor,
        backgroundColor: UIColor,
        topLeft: CGFloat,
        topRight: CGFloat,
        bottomLeft: CGFloat,
        bottomRight: CGFloat
    ) {
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        
        self.roundCorners(topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight)
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = (self.layer.mask! as! CAShapeLayer).path!
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
}
