//
//  RecentDescriptionView.swift
//  Kerdy
//
//  Created by 이동현 on 12/21/23.
//

import UIKit

final class RecentDescriptionView: UIView {
    private lazy var recentLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.font = .nanumSquare(to: .bold, size: 13)
        return label
    }()
    
    lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        return button
    }()
    
    private lazy var clearLabel: UILabel = {
        let label = UILabel()
        label.text = "전체 삭제"
        label.font = .nanumSquare(to: .bold, size: 12)
        label.textColor = .kerdyGray01
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - layout 설정
extension RecentDescriptionView {
    private func setLayout() {
        addSubviews(
            recentLabel,
            clearLabel,
            clearButton
        )
        
        recentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(15)
        }
        
        clearLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(47)
            $0.height.equalTo(16)
        }
        
        clearButton.snp.makeConstraints {
            $0.edges.equalTo(clearLabel.snp.edges)
        }
    }
}
