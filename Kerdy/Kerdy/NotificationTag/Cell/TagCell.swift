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
    
    private var type: TagType = .userTag {
        didSet {
            setBorderLayer()
        }
    }
    
    var disposeBag = DisposeBag()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setBorderLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Methods

extension TagCell {
    
    private func setLayout() {
        
        contentView.layer.addSublayer(borderLayer)
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
    }
    
    private func setRegisterTag() {
        
        borderLayer.configureBorder(of: contentView,
                                    withStroke: .kerdyMain,
                                    withFill: .clear,
                                    using: 2)
        
    }
    
    private func setUserTag() {
        
        titleLabel.sizeToFit()
        
        titleLabel.snp.remakeConstraints {
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
        
        configureBackground()
    }
    
    private func setBorderLayer() {
        
        setUI()
        type == .userTag ? setUserTag() : setRegisterTag()
    }
    
    func configureCell(to type: TagsResponseDTO, tagType: TagType) {
        
        self.type = tagType
        titleLabel.text = type.name
        cancelButton.tag = type.id
    }
    
    func configureBackground() {
        
        layoutIfNeeded()
        borderLayer.configureBorder(of: contentView,
                                    withStroke: .kerdyMain,
                                    withFill: .kerdyMain,
                                    using: 2)
    }
    
}

// MARK: - Reactive extension

extension Reactive where Base: TagCell {
    
    var cancel: ControlEvent<Void> {
        base.cancelButton.rx.tap
    }
}
