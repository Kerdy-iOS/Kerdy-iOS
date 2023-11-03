//
//  TagView.swift
//  Temp
//
//  Created by 이동현 on 10/30/23.
//

import UIKit

final class TagView: UIView {
    private lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()

    init() {
        super.init(frame: .zero)
        setLayout()
        setUI()
    }

    private func setLayout() {
        addSubview(tagLabel)
        
        tagLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setUI() {
        self.roundCorners(topLeft: 8, topRight: 15, bottomLeft: 15, bottomRight: 8)
        
        if let maskLayer = self.layer.mask as? CAShapeLayer {
            let borderLayer = CAShapeLayer()
            borderLayer.path = maskLayer.path
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.frame = bounds
            layer.addSublayer(borderLayer)
        }
    }

    func setTitle(tag: String) {
        tagLabel.text = String(tag)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
