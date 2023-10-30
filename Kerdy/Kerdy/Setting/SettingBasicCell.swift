//
//  SettingBasicCell.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 10/31/23.
//

import UIKit

import SnapKit
import Core

private struct Const {
    
    static let size:CGFloat = 14
}

final class SettingBasicCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: Const.size)
        return label
    }()
    
    private let arrowIcon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 14)
        label.textColor = .kerdyGray02
        return label
    }()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setLayout()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Setting

extension SettingBasicCell {
    
    private func setLayout() {
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.remakeConstraints {
            $0.centerY.equalToSuperview()
            $0.verticalEdges.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(17)
        }
    }
    
    private func configureArrowIcon() {
        
        contentView.addSubview(arrowIcon)
        arrowIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(17)
            $0.size.equalTo(12)
        }
    }
    
    private func configureVersion() {
        
        contentView.addSubview(versionLabel)
        versionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(17)
        }
    }
    
    private func setUI() {
        
        contentView.backgroundColor = .clear
        
    }
    
    
}

// MARK: - Methods

extension SettingBasicCell {
    
    func configureData(to data: BasicModel, of index: Int) {
        titleLabel.text = data.title
        arrowIcon.image = data.image
        versionLabel.text = data.version
        
        switch index {
        case 0...2:
            configureArrowIcon()
        case 3:
            configureVersion()
        case 5:
            titleLabel.textColor = .red
        default:
            break
        }
    }
    
}
