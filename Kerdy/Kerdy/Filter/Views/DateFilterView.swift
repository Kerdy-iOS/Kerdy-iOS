//
//  DateFilterView.swift
//  Kerdy
//
//  Created by 이동현 on 11/3/23.
//

import UIKit
import Core

final class DateFilterView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "기간"
        label.font = .nanumSquare(to: .bold, size: 15)
        return label
    }()

    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        return stackView
    }()

    lazy var startDateBtnView = DateSelectBtnView()
    lazy var endDateBtnView = DateSelectBtnView()

    lazy var waveLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 15)
        label.text = "~"
        return label
    }()

    init() {
        super.init(frame: .zero)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        addSubviews(titleLabel)
        addSubviews(dateStackView)
        setDateStackViewLayout()

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(17)
            $0.size.width.equalTo(28).priority(250)
            $0.size.height.equalTo(19).priority(250)
        }

        dateStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(17)
            $0.size.width.equalTo(100).priority(250)
            $0.size.height.equalTo(45).priority(250)
        }
    }

    func setUI() {
        startDateBtnView.setUnselected()
        endDateBtnView.setUnselected()
    }

    private func setDateStackViewLayout() {
        dateStackView.addArrangedSubview(startDateBtnView)
        dateStackView.addArrangedSubview(waveLabel)
        dateStackView.addArrangedSubview(endDateBtnView)

        startDateBtnView.snp.makeConstraints {
            $0.width.equalTo(125)
            $0.height.equalTo(45)
        }

        endDateBtnView.snp.makeConstraints {
            $0.width.equalTo(125)
            $0.height.equalTo(45)
        }

        waveLabel.snp.makeConstraints {
            $0.width.equalTo(19)
        }
    }
}
