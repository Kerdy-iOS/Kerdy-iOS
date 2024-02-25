//
//  ArchiveCell.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 1/7/24.
//

import UIKit

import Core
import SnapKit

import RxSwift
import RxCocoa

final class ArchiveCell: UICollectionViewCell {
    
    // MARK: - Property
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let profile: UIImageView = {
        let image = UIImageView()
        image.makeCornerRound(radius: 48/2)
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 14)
        label.textColor = .kerdyBlack
        return label
    }()
    
    private let content: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 12)
        label.textColor = .kerdyBlack
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 12)
        label.textColor = .kerdyGray04
        return label
    }()
    
    fileprivate lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(.archiveCancelIcon, for: .normal)
        return button
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

// MARK: - Methods

extension ArchiveCell {
    
    private func setLayout() {
        
        contentView.addSubview(profile)
        profile.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().inset(17)
            $0.size.equalTo(48)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(profile.snp.top)
            $0.leading.equalTo(profile.snp.trailing).offset(15)
        }
        
        contentView.addSubview(content)
        content.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(profile.snp.trailing).offset(15)
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(content.snp.bottom).offset(8)
            $0.leading.equalTo(profile.snp.trailing).offset(15)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(profile.snp.top)
            $0.trailing.equalToSuperview().inset(17)
            $0.size.equalTo(15)
        }
    }
}

extension ArchiveCell {
    
    func configure(data: ArchiveResponseDTO) {
        timeLabel.text = data.convertDate
        
        switch data.notificationInformation {
        case .comment(let commentInfo):
            titleLabel.text = commentInfo.title
            content.text = commentInfo.content
            profile.kf.setImage(with: URL(string: commentInfo.profile ?? ""), placeholder: UIImage.emptyIcon)
            
        case .event(let eventInfo):
            titleLabel.text = eventInfo.title ?? "관심 태그 행사가 업데이트 되었어요."
            profile.image = .emptyIcon
            content.text = eventInfo.title
        }
    }
}

// MARK: - Reactive extension

extension Reactive where Base: ArchiveCell {

    var delete: ControlEvent<Void> {
        base.deleteButton.rx.tap
    }
}
