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
        view.image = .imgUser
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 11)
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1000
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()
    
    private lazy var cornerView: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray01
        return view
    }()
    
    private lazy var messageView: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray01
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .kerdyGray02
        label.textAlignment = .left
        label.font = .nanumSquare(to: .regular, size: 9)
        return label
    }()
    
    private var viewModel = ChatDetailCellViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(isContinuous: Bool, data: MessageRoomResponseDTO) {
        if isContinuous {
            messageView.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(4)
                $0.leading.equalToSuperview().offset(36)
                $0.height.equalTo(30).priority(500)
                $0.width.lessThanOrEqualToSuperview().offset(-89)
            }
            profileImageView.isHidden = isContinuous
            nameLabel.isHidden = isContinuous
        } else {
            // TODO: - 이미지 다운로드
            nameLabel.text = data.sender.name
        }
        contentLabel.text = data.content
        timeLabel.text = convertDateToTime(date: data.createdAt)
        layoutIfNeeded()
    }
    
}

extension IncomingChatCollectionViewCell {
    private func setLayout() {
        contentView.addSubviews(
            profileImageView,
            nameLabel,
            cornerView,
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
            $0.leading.equalToSuperview().offset(36)
            $0.height.equalTo(14)
        }
        
        messageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().offset(36)
            $0.height.equalTo(30).priority(500)
            $0.width.lessThanOrEqualToSuperview().offset(-89)
        }
        
        cornerView.snp.makeConstraints {
            $0.top.equalTo(messageView.snp.top)
            $0.leading.equalToSuperview().offset(36)
            $0.size.equalTo(15)
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(messageView.snp.trailing).offset(5)
            $0.bottom.equalTo(messageView.snp.bottom)
            $0.width.equalTo(48)
            $0.height.equalTo(13)
        }
        
        contentLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(7)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.width.greaterThanOrEqualTo(10)
        }
    }
}

