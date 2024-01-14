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
        
    }
}

extension MyChatCollectionViewCell {
    private func setLayout() {
        contentLabel.addSubviews(messageView, timeLabel)
        messageView.addSubview(contentLabel)
        
        messageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(30).priority(500)
            $0.width.lessThanOrEqualToSuperview().inset(53)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalTo(messageView.snp.leading).inset(5)
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
    
    func setLayer() {
        self.roundCorners(
            topLeft: 15,
            topRight: 0,
            bottomLeft: 15,
            bottomRight: 15
        )
    }
}
