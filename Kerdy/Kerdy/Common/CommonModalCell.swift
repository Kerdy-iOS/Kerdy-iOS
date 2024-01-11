//
//  CommonModalCell.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 1/11/24.
//

import UIKit

import Core

final class CommonModalCell: UICollectionViewCell {
    
    // MARK: - Property
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 14)
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methds

extension CommonModalCell {
    
    private func setLayout() {
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(17)
            $0.verticalEdges.equalToSuperview().inset(21)
        }
    }
    
    func configureData(to data: CommonModalItem) {
        titleLabel.text = data.type.title
        titleLabel.textColor = data.titleColor
    }
}
