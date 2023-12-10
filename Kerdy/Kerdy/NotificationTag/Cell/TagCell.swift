//
//  TagCell.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/1/23.
//

import UIKit

import Core
import SnapKit

import RxSwift
import RxCocoa

enum TagType {
    
    case userTag, registerTag
}

final class TagCell: UICollectionViewCell {
    
    // MARK: - Proprerty
    
    var disposeBag = DisposeBag()
    private var type: TagType = .userTag {
        didSet {
            setBorderLayer()
        }
    }
    
    // MARK: - UI Property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 13)
        label.textColor = .kerdyBlack
        return label
    }()
    
    fileprivate let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(.tagCancelIcon, for: .normal)
        return button
    }()
    
    private let borderLayer = CAShapeLayer()
    
    // MARK: - Initialize
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setBorderLayer()
    }
}

// MARK: - Methods

extension TagCell {
    
    private func setBorderLayer() {
        
        contentView.backgroundColor = .kerdyBackground
        contentView.roundCorners(topLeft: 12,
                                 topRight: 20,
                                 bottomLeft: 20,
                                 bottomRight: 12)
        
        contentView.layer.addSublayer(borderLayer)
        contentView.addSubview(titleLabel)
        
        type == .userTag ? setUserTag() : setRegisterTag()
    }
    
    private func setRegisterTag() {
        configureBackground()
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setUserTag() {
        configureFillBackground()
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview().inset(15)
            $0.size.equalTo(10)
        }
    }
    
    func configureFillBackground() {
        
        layoutIfNeeded()
        borderLayer.configureBorder(of: contentView,
                                    withStroke: .kerdyMain,
                                    withFill: .kerdyMain,
                                    using: 2)
    }
    
    func configureBackground() {
        
        layoutIfNeeded()
        borderLayer.configureBorder(of: contentView,
                                    withStroke: .kerdyMain,
                                    withFill: .clear,
                                    using: 2)
    }
    
    func configureCell(to type: TagsResponseDTO, tagType: TagType) {
        
        self.type = tagType
        titleLabel.text = type.name
        cancelButton.tag = type.id
    }
}

// MARK: - Reactive extension

extension Reactive where Base: TagCell {
    
    var cancel: ControlEvent<Void> {
        base.cancelButton.rx.tap
    }
}
