//
//  PrortudingBtn.swift
//  Kerdy
//
//  Created by 이동현 on 11/6/23.
//

import UIKit

class PrortudingBtn: UIButton {
    
    init(
        title: String,
        titleColor: UIColor,
        fontSize: CGFloat,
        backgroundColor: UIColor
    ) {
        super.init(frame: .zero)
        setUI(
            title: title,
            titleColor: titleColor,
            fontSize: fontSize,
            backgroundColor: backgroundColor
        )
    }

    private func setUI(title: String, titleColor: UIColor, fontSize: CGFloat, backgroundColor: UIColor) {
        titleLabel?.font = .nanumSquare(to: .regular, size: fontSize)
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
    }

    func setLayer(
        topLeft: CGFloat,
        topRight: CGFloat,
        bottomLeft: CGFloat,
        bottomRight: CGFloat,
        strokeColor: UIColor
    ) {
        self.roundCorners(topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight)
        let borderLayer = CAShapeLayer()
        guard
            let maskLayer = layer.mask as? CAShapeLayer,
            let path = maskLayer.path
        else { return }
        borderLayer.path = path
        borderLayer.strokeColor = strokeColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 3
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
