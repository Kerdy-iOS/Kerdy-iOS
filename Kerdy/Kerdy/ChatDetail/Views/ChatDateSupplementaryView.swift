//
//  ChatDateSupplementaryView.swift
//  Kerdy
//
//  Created by 이동현 on 1/14/24.
//

import UIKit
import SnapKit

final class ChatDateSupplementaryView: UICollectionReusableView {    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 10)
        label.textColor = .kerdyGray02
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(date: String) {
        dateLabel.text = date
    }
}

extension ChatDateSupplementaryView {
    func setLayout() {
        addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-14)
            $0.centerX.equalToSuperview()
        }
    }
}
