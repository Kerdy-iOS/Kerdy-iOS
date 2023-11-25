//
//  EventSummaryInfoView.swift
//  Kerdy
//
//  Created by 이동현 on 11/24/23.
//

import UIKit
import SnapKit

final class EventSummaryInfoView: UIView {
    private lazy var titleStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.alignment = .leading
        view.distribution = .equalSpacing
        return view
    }()
    
    private lazy var applyTitle: UILabel = {
        let label = UILabel()
        label.text = "접수기간"
        label.font = .nanumSquare(to: .bold, size: 12)
        return label
    }()
    
    private lazy var dateTitle: UILabel = {
        let label = UILabel()
        label.text = "일시"
        label.font = .nanumSquare(to: .bold, size: 12)
        return label
    }()
    
    private lazy var locationTitle: UILabel = {
        let label = UILabel()
        label.text = "장소"
        label.font = .nanumSquare(to: .bold, size: 12)
        return label
    }()
    
    private lazy var costTitle: UILabel = {
        let label = UILabel()
        label.text = "비용"
        label.font = .nanumSquare(to: .bold, size: 12)
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.alignment = .leading
        view.distribution = .equalSpacing
        return view
    }()
    
    private lazy var applyInfo: UILabel = {
        let label = UILabel()
        label.text = "접수기간"
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()
    
    private lazy var dateInfo: UILabel = {
        let label = UILabel()
        label.text = "일시"
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()
    
    private lazy var locationInfo: UILabel = {
        let label = UILabel()
        label.text = "장소"
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()
    
    private lazy var costInfo: UILabel = {
        let label = UILabel()
        label.text = "비용"
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()

    init() {
        super.init(frame: .zero)
        setLayout()
    }

    private func setLayout() {
        addSubviews(titleStackView, infoStackView)
        setTitleLayout()
        setInfoLayout()
        
        titleStackView.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview()
        }
        
        infoStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(titleStackView.snp.trailing).offset(20)
        }
    }

    private func setTitleLayout() {
        titleStackView.addArrangedSubviews(
            applyTitle,
            dateTitle,
            locationTitle,
            costTitle
        )
    }
    
    private func setInfoLayout() {
        infoStackView.addArrangedSubviews(
            applyInfo,
            dateInfo,
            locationInfo,
            costInfo
        )
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
