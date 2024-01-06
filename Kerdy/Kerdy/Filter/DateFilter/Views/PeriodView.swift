//
//  PeriodView.swift
//  Kerdy
//
//  Created by 이동현 on 11/8/23.
//

import UIKit
import SnapKit

final class PeriodView: UIView {
    private(set) lazy var startLabel: UILabel = {
        let label = UILabel()
        label.text = "시작일 선택"
        return label
    }()
    
    private(set) lazy var endLabel: UILabel = {
        let label = UILabel()
        label.text = "종료일 선택"
        return label
    }()
    
    private lazy var dateStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.distribution = .fillEqually
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setLayout()
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        addSubviews(dateStackView)
        dateStackView.addArrangedSubviews(startLabel, endLabel)
        dateStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setUI() {
        [startLabel, endLabel].forEach {
            $0.textAlignment = .center
            $0.font = .nanumSquare(to: .bold, size: 12)
            $0.layer.borderColor = UIColor.kerdyMain.cgColor
            $0.layer.borderWidth = 0.7
            $0.layer.cornerRadius = 15
        }
    }
    
    func reset() {
        startLabel.text = "시작일 선택"
        endLabel.text = "종료일 선택"
    }
    
    func setStartDate(date: String) {
        startLabel.text = date
    }
    
    func setEndDate(date: String) {
        endLabel.text = date
    }
}
