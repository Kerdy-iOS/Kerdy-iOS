//
//  TagView.swift
//  Temp
//
//  Created by 이동현 on 10/30/23.
//

import UIKit

final class TagView: UIView {
    private lazy var backgroundView = UIView()
    
    private lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .kerdySub
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()

    init() {
        super.init(frame: .zero)
        setLayout()
    }

    private func setLayout() {
        addSubview(backgroundView)
        backgroundView.addSubview(tagLabel)
        backgroundView.snp.makeConstraints {
            $0.width.equalTo(50).priority(500)
            $0.height.equalTo(22)
            $0.edges.equalToSuperview()
        }
        
        tagLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.verticalEdges.equalToSuperview().inset(3)
        }
    }
    
    func setLayer() {
        backgroundView.roundCorners(topLeft: 8, topRight: 15, bottomLeft: 15, bottomRight: 8)
        
        if let maskLayer = backgroundView.layer.mask as? CAShapeLayer {
            let borderLayer = CAShapeLayer()
            borderLayer.path = maskLayer.path
            borderLayer.fillColor = UIColor.kerdySub.cgColor
            borderLayer.frame = backgroundView.bounds
            backgroundView.layer.addSublayer(borderLayer)
        }
    }

    func setTitle(tag: String?) {
        tagLabel.text = tag
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
