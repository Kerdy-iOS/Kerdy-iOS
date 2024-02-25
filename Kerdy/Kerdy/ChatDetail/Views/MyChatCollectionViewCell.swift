//
//  MyChatCollectionViewCell.swift
//  Kerdy
//
//  Created by 이동현 on 1/14/24.
//

import UIKit

final class MyChatCollectionViewCell: UICollectionViewCell {
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1000
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()
    
    private lazy var messageView: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyMain
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var cornerView: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyMain
        return view
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .kerdyGray02
        label.text = "12:34"
        label.textAlignment = .right
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
                $0.trailing.equalToSuperview()
                $0.height.equalTo(30).priority(500)
                $0.width.lessThanOrEqualToSuperview().offset(-89)
            }
        }
        
        contentLabel.text = data.content
        timeLabel.text = convertDateToTime(date: data.createdAt)
        layoutIfNeeded()
    }
}

extension MyChatCollectionViewCell {
    private func setLayout() {
        contentView.addSubviews(
            cornerView,
            messageView,
            timeLabel
        )
        messageView.addSubview(contentLabel)
                
        messageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(30).priority(500)
            $0.width.lessThanOrEqualToSuperview().offset(-89)
        }
        
        cornerView.snp.makeConstraints {
            $0.top.equalTo(messageView.snp.top)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(15)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalTo(messageView.snp.leading).offset(-5)
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
