//
//  FilterBtn.swift
//  Kerdy
//
//  Created by 이동현 on 11/5/23.
//

import UIKit

class FilterBtn: UIButton {

    init(title: String, tag: Int) {
        super.init(frame: .zero)
        setUI(title: title, tag: tag)
    }

    private func setUI(title: String, tag: Int) {
        titleLabel?.font = .nanumSquare(to: .regular, size: 13)
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        self.tag = tag
        setBtnColor()
    }

    func setBtnColor() {
        if isSelected {
            backgroundColor = .kerdyMain
        } else {
            backgroundColor = .white
        }
    }

    func setLayer() {
        self.roundCorners(topLeft: 12, topRight: 20, bottomLeft: 20, bottomRight: 12)
        let borderLayer = CAShapeLayer()
        guard 
            let maskLayer = layer.mask as? CAShapeLayer,
            let path = maskLayer.path
        else { return }
        borderLayer.path = path
        borderLayer.strokeColor = UIColor(named: "kerdy_main")?.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 3
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
