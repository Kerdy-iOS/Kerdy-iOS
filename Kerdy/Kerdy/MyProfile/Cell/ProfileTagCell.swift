//
//  ProfileTagCell.swift
//  Kerdy
//
//  Created by 최다경 on 12/24/23.
//

import UIKit

final class ProfileTagCell: UICollectionViewCell {
    private lazy var tagBackground: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 13)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayer()
    }
    
    func confiure(tag: String) {
        tagLabel.text = tag
    }
}

extension ProfileTagCell {
    private func setLayout() {
        addSubview(tagBackground)
        tagBackground.addSubview(tagLabel)
        
        tagBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tagLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(14)
            $0.verticalEdges.equalToSuperview().inset(8)
        }
    }

    func setLayer() {
        self.roundCorners(
            topLeft: 12,
            topRight: 20,
            bottomLeft: 20,
            bottomRight: 12
        )
        let borderLayer = CAShapeLayer()
        guard
            let maskLayer = layer.mask as? CAShapeLayer,
            let path = maskLayer.path
        else { return }
        borderLayer.path = path
        borderLayer.strokeColor = UIColor.kerdyMain.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 3
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
}

extension ProfileTagCell {
    func setBackgroundColor(isSelected: Bool) {
        let color = isSelected ? UIColor.kerdyMain : UIColor.white
        tagBackground.backgroundColor = color
    }
}
