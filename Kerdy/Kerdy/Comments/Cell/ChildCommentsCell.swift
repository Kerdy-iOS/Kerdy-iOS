//
//  ChildCommentsCell.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/17/23.
//

import UIKit

import Core
import SnapKit

import RxSwift
import RxCocoa

final class ChildCommentsCell: UICollectionViewCell {
    
    // MARK: = UI Components
    
    private let arrowIcon: UIImageView = {
        let view = UIImageView()
        view.image = .commentsArrowIcon
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let profile: UIImageView = {
        let view = UIImageView()
        view.makeBorder(width: 1, color: .kerdyGray01)
        view.makeCornerRound(radius: 15)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let userLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 12)
        label.textColor = .kerdyBlack
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 11)
        label.textColor = .kerdyGray02
        return label
    }()
    
    private let commentsLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 13)
        label.textColor = .kerdyBlack
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var dotButton: UIButton = {
        let button = UIButton()
        button.setImage(.dotButton, for: .normal)
        return button
    }()
    
    // MARK: = Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Methods

extension ChildCommentsCell {
    
    private func setLayout() {
        
        contentView.addSubview(arrowIcon)
        arrowIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(13)
            $0.size.equalTo(20)
        }
        
        contentView.addSubview(profile)
        profile.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalTo(arrowIcon.snp.trailing).offset(9)
            $0.size.equalTo(30)
        }
        
        contentView.addSubview(userLabel)
        userLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalTo(profile.snp.trailing).offset(9)
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(userLabel.snp.bottom).offset(4)
            $0.leading.equalTo(profile.snp.trailing).offset(9)
        }
        
        contentView.addSubview(dotButton)
        dotButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.trailing.equalToSuperview().inset(17)
            $0.size.equalTo(23)
        }
        
        contentView.addSubview(commentsLabel)
        commentsLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.leading.equalTo(profile.snp.leading)
            $0.trailing.equalToSuperview().inset(17)
            $0.bottom.equalToSuperview().inset(14)
        }
    }
    
    func configureCell(with data: Comment ) {
        
        guard let url = URL(string: data.memberImageURL ) else { return }
        profile.kf.setImage(with: url, placeholder: UIImage.emptyIcon)
        
        userLabel.text = data.deleted ? "삭제" : data.memberName ?? "KERDY"
        dateLabel.text = data.timeAgoSinceDate()
        commentsLabel.text = data.content
    
        deleteComments(isDeleted: data.deleted)
    }
    
    func deleteComments(isDeleted: Bool) {
        dotButton.isHidden = isDeleted
        dateLabel.isHidden = isDeleted
        
        if isDeleted {
            profile.image = .emptyIcon
            profile.makeBorder(width: 0, color: .clear)
        }
    }
}

// MARK: - Reactive extension

extension Reactive where Base: ChildCommentsCell {

    var dot: ControlEvent<Void> {
        base.dotButton.rx.tap
    }
}
