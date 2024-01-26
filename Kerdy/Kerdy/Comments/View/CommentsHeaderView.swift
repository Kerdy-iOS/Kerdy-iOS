//
//  CommentsHeaderView.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/18/23.
//

import UIKit

import Core
import SnapKit
import Kingfisher

import RxSwift
import RxCocoa

final class CommentsHeaderView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let profile: UIImageView = {
        let view = UIImageView()
        view.makeCornerRound(radius: 20)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let userLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 13)
        label.textColor = .kerdyBlack
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 11)
        label.textColor = .kerdyGray02
        return label
    }()
    
    private let parentComments: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 13)
        label.textColor = .kerdyBlack
        label.numberOfLines = 0
        return label
    }()
    
    private let commentsCount: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 11)
        label.textColor = .kerdyGray02
        return label
    }()
    
    fileprivate lazy var dotButton: UIButton = {
        let button = UIButton()
        button.setImage(.dotButton, for: .normal)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension CommentsHeaderView {
    
    private func setLayout() {
        
        addSubview(profile)
        profile.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(17)
            $0.size.equalTo(40)
        }
        
        addSubview(userLabel)
        userLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.leading.equalTo(profile.snp.trailing).offset(9)
        }
        
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(userLabel.snp.bottom).offset(6)
            $0.leading.equalTo(profile.snp.trailing).offset(9)
        }
        
        addSubview(parentComments)
        parentComments.snp.makeConstraints {
            $0.top.equalTo(profile.snp.bottom).offset(12)
            $0.leading.equalTo(profile.snp.trailing).offset(9)
            $0.trailing.equalToSuperview().inset(17)
        }
        
        addSubview(commentsCount)
        commentsCount.snp.makeConstraints {
            $0.top.equalTo(parentComments.snp.bottom).offset(10)
            $0.leading.equalTo(profile.snp.trailing).offset(9)
            $0.bottom.equalToSuperview().inset(17)
        }
        
        addSubview(dotButton)
        dotButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.trailing.equalToSuperview().inset(17)
            $0.size.equalTo(23)
        }
    }
    
    func configureHeader(with data: Comment, count: Int) {
        
        guard let url = URL(string: data.memberImageURL ) else { return }
        profile.kf.setImage(with: url, placeholder: UIImage.emptyIcon)
        
        userLabel.text = data.memberName ?? "KERDY"
        timeLabel.text = data.timeAgoSinceDate()
        parentComments.text = data.content
        commentsCount.text = "답글" + "\(count)"
        dotButton.isHidden = data.deleted
    }
}

// MARK: - Reactive extension

extension Reactive where Base: CommentsHeaderView {

    var dot: ControlEvent<Void> {
        base.dotButton.rx.tap
    }
}
