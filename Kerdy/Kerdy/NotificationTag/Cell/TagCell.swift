//
//  TagCell.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/1/23.
//

import UIKit

import Core
import SnapKit

final class TagCell: UICollectionViewCell {
    
    // MARK: - UI Property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 13)
        label.textColor = .kerdyBlack
        return label
    }()
    
    private let borderLayer = CAShapeLayer()
    
    
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Methods

extension TagCell {
    
    private func setLayout() {
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    private func setUI() {
        
        contentView.backgroundColor = .kerdyBackground
        contentView.roundCorners(topLeft: 12,
                                 topRight: 20,
                                 bottomLeft: 20,
                                 bottomRight: 12)
        
        borderLayer.configureBorder(of: contentView,
                                    withStroke: .kerdyMain,
                                    withFill: .clear,
                                    using: 2)
    }
    
    func configureCell(to type: TagType) {
        titleLabel.text = type.title
    }

}
