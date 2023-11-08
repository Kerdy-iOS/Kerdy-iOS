//
//  ProgressFilterView.swift
//  Kerdy
//
//  Created by 이동현 on 11/3/23.
//

import UIKit
import Core

final class ProgressFilterView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "진행 상태"
        label.font = .nanumSquare(to: .bold, size: 15)
        return label
    }()

    private lazy var progressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var divideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)

    lazy var inProgressBtn = FilterBtn(title: "진행중")
    lazy var isPlanned = FilterBtn(title: "진행예정")
    lazy var isFinished = FilterBtn(title: "마감")

    init() {
        super.init(frame: .zero)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        addSubviews(
            titleLabel,
            progressStackView,
            divideLine
        )
        setProgressStackViewLayout()

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(17)
            $0.size.width.equalTo(28).priority(250)
            $0.size.height.equalTo(19).priority(250)
        }

        progressStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(17)
            $0.size.width.equalTo(250).priority(250)
            $0.size.height.equalTo(33).priority(250)
        }

        divideLine.snp.makeConstraints {
            $0.top.equalTo(progressStackView.snp.bottom).offset(26)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }

    private func setProgressStackViewLayout() {
        progressStackView.addArrangedSubviews(
            inProgressBtn,
            isPlanned,
            isFinished
        )

        inProgressBtn.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.width.equalTo(86)
        }

        isPlanned.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.width.equalTo(98)
        }

        isFinished.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.width.equalTo(74)
        }
    }

    func setUI() {
        inProgressBtn.setLayer()
        isPlanned.setLayer()
        isFinished.setLayer()
    }
}
