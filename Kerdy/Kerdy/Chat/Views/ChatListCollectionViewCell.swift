//
//  ChatListCollectionViewCell.swift
//  Kerdy
//
//  Created by 이동현 on 1/14/24.
//

import UIKit
import SnapKit

final class ChatListCollectionViewCell: UICollectionViewCell {
    private lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 14)
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 10)
        label.textColor = .kerdyGray01
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
        
    }
}

// MARK: - layout 설정
extension ChatListCollectionViewCell {
    private func setLayout() {
        contentView.addSubviews(
            profileImageView,
            nameLabel,
            contentLabel,
            timeLabel
        )
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.verticalEdges.equalToSuperview().inset(11)
            $0.leading.equalToSuperview().inset(17)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(11)
            $0.leading.equalTo(profileImageView.snp.trailing).inset(8)
            $0.height.equalTo(18)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).inset(5)
            $0.leading.equalTo(profileImageView.snp.trailing).inset(8)
            $0.height.equalTo(16)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(11)
            $0.trailing.equalToSuperview().inset(17)
            $0.height.equalTo(13)
        }
    }
}
