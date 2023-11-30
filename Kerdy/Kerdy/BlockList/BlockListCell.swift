//
//  BlockListCell.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import UIKit

import Core
import SnapKit

import RxCocoa
import RxSwift

final class BlockListCell: UICollectionViewCell {
    
    // MARK: - Property
    
    // MARK: - UI Property
    
    private let profile: UIImageView = {
        let image = UIImageView()
        image.makeCornerRound(radius: 48/2)
        image.backgroundColor = .kerdyMain
        return image
    }()
    
    private let userID: UILabel = {
       let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 15)
        label.textColor = .kerdyBlack
        return label
    }()
    
    private lazy var blockButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.kerdyStyle(to: Strings.unblock,
                                                   withBackground: .kerdyMain,
                                                   withForeground: .kerdyBackground,
                                                   withStroke: .kerdyMain,
                                                   using: 1.0,
                                                   font: .nanumSquare(to: .bold, size: 11)
        )
        
        return button
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

// MARK: - Methods

extension BlockListCell {
    
    private func setLayout() {
        
        contentView.addSubview(profile)
        profile.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(17)
            $0.size.equalTo(48)
        }
        
        contentView.addSubview(userID)
        userID.snp.makeConstraints {
            $0.leading.equalTo(profile.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(blockButton)
        blockButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(17)
            $0.size.equalTo(CGSize(width: 109, height: 30))
        }
    }
    
    private func setUI() {
        
        contentView.backgroundColor = .kerdyBackground
        
    }
    
    func configureCell(to data: BlockListModel) {
        profile.backgroundColor = data.profile
        userID.text = data.userId
    }
}
