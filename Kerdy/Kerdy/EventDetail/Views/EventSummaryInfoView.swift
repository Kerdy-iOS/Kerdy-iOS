//
//  EventSummaryInfoView.swift
//  Kerdy
//
//  Created by 이동현 on 11/24/23.
//

import UIKit
import SnapKit

final class EventSummaryInfoView: UIView {
    private lazy var dDayLabel: UILabel = {
        let label = UILabel()
        label.text = "D-day"
        label.textColor = .kerdyMain
        label.font = .nanumSquare(to: .extraBold, size: 13)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "AWS 부산 클라우드데이 2023 AWS"
        label.font = .nanumSquare(to: .bold, size: 15)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var organizerLabel: UILabel = {
        let label = UILabel()
        label.text = "부산정보산업진흥원"
        label.textColor = .kerdyGray03
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()
    
    private lazy var filterStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 3
        view.alignment = .leading
        view.distribution = .equalSpacing
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    private func setLayout() {
        addSubviews(
            dDayLabel,
            titleLabel,
            organizerLabel,
            filterStackView
        )
        setFilterLayout()
        
        dDayLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(17)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dDayLabel.snp.bottom).offset(9)
            $0.leading.equalTo(dDayLabel.snp.leading)
        }
        
        organizerLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.equalTo(dDayLabel.snp.leading)
        }
        
        filterStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-17)
            $0.top.equalTo(organizerLabel.snp.bottom).offset(23)
            $0.height.equalTo(22)
        }
    }
    
    private func setFilterLayout() {
        //필터 관련 레이아웃
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
