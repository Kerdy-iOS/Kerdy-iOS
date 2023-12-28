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
            setLayout()
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
    
    private var borderLayer =  CAShapeLayer()
    
    // MARK: - Initialize
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setLayout()
        setUI()
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
        
        if type == .userTag { setUserTag() } else { setRegisterTag() }
    }
    
    private func setUI() {
        
        contentView.backgroundColor = .kerdyMain
    }
    
    private func setBorderLayer() {
        
        contentView.roundCorners(topLeft: 12, topRight: 20, bottomLeft: 20, bottomRight: 12)
    }
    
    private func setRegisterTag() {
        cancelButton.removeFromSuperview()
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setUserTag() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(cancelButton)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview().inset(15)
            $0.size.equalTo(10)
        }
    }
    
    func configureCell(to type: TagsResponseDTO, tagType: TagType) {
        
        self.type = tagType
        titleLabel.text = type.name
    }
    
    func configureButton(isSelected: Bool) {
        
        contentView.backgroundColor = isSelected ? .kerdyMain : .clear
    }
}

// MARK: - Reactive extension

extension Reactive where Base: TagCell {
    
    var cancel: ControlEvent<Void> {
        base.cancelButton.rx.tap
    }
}
