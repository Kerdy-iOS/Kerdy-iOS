//
//  File.swift
//  
//
//  Created by 이동현 on 11/2/23.
//

import UIKit

public class ProtrudingBtn: UIButton {
    
    public init(frame: CGRect, title: String, titleColor: UIColor, backgroundColor: UIColor) {
        super.init(frame: frame)
        setupButton(title: title, titleColor: titleColor, backgroundColor: backgroundColor)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton(title: "", titleColor: .black, backgroundColor: .gray)
    }
    
    private func setupButton(title: String, titleColor: UIColor, backgroundColor: UIColor) {
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
    
        self.roundCorners(topLeft: 8, topRight: 15, bottomLeft: 15, bottomRight: 8)
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = (self.layer.mask! as! CAShapeLayer).path!
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
}
