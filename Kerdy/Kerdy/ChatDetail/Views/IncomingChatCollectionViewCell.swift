//
//  IncomingCollectionViewCell.swift
//  Kerdy
//
//  Created by 이동현 on 1/14/24.
//

import UIKit
import SnapKit

final class IncomingChatCollectionViewCell: UICollectionViewCell {
    private lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 11)
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1000
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()
    
    private lazy var messageView: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray01
        return view
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .kerdyGray02
        label.font = .nanumSquare(to: .regular, size: 9)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        // TODO: - profile이미지 없으면 이미지 nil값 설정
    }
}

extension IncomingChatCollectionViewCell {
    private func setLayout() {
        contentLabel.addSubviews(
            profileImageView,
            nameLabel,
            messageView,
            timeLabel
        )
        
        messageView.addSubview(contentLabel)
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing).inset(6)
            $0.height.equalTo(14)
        }
        
        messageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(profileImageView.snp.trailing).inset(6)
            $0.height.equalTo(30).priority(500)
            $0.width.lessThanOrEqualToSuperview().inset(53)
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(messageView.snp.trailing).inset(5)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(48)
            $0.height.equalTo(13)
        }
        
        contentLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(7)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(16).priority(750)
        }
    }
    
    private func setLayoutWithoutName() {
        profileImageView.isHidden = true
        nameLabel.isHidden = true
        
        messageView.snp.updateConstraints {
            $0.top.equalToSuperview()
        }
    }
    
    func setLayer() {
        self.roundCorners(
            topLeft: 0,
            topRight: 15,
            bottomLeft: 15,
            bottomRight: 15
        )
    }
}
