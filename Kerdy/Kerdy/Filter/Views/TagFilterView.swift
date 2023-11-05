//
//  TagFilterView.swift
//  Kerdy
//
//  Created by 이동현 on 11/3/23.
//

import UIKit
import Core

final class TagFilterView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "태그"
        label.font = .nanumSquare(to: .bold, size: 15)
        return label
    }()

    private lazy var tagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 11
        stackView.distribution = .equalSpacing
        return stackView
    }()

    lazy var innerStackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()

    lazy var innerStackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var divideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)

    lazy var entireBtn = FilterBtn(title: "전체", tag: 0)
    lazy var androidBtn = FilterBtn(title: "Android", tag: 0)
    lazy var iOSBtn = FilterBtn(title: "iOS", tag: 0)
    lazy var frontendBtn = FilterBtn(title: "Frontend", tag: 0)
    lazy var backendBtn = FilterBtn(title: "Backend", tag: 0)
    lazy var aiBtn = FilterBtn(title: "AI", tag: 0)

    init() {
        super.init(frame: .zero)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        addSubviews(titleLabel)
        addSubviews(tagStackView)
        addSubviews(divideLine)
        setInnerStackView()

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.equalToSuperview().offset(17)
            $0.size.width.equalTo(28).priority(250)
            $0.size.height.equalTo(19).priority(250)
        }

        tagStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(17)
            $0.size.width.equalTo(250).priority(250)
            $0.size.height.equalTo(70).priority(250)
        }

        divideLine.snp.makeConstraints {
            $0.top.equalTo(tagStackView.snp.bottom).offset(26)
            $0.horizontalEdges.equalToSuperview()
            $0.size.height.equalTo(0.5)
        }
    }

    private func setInnerStackView() {
        tagStackView.addArrangedSubview(innerStackView1)
        tagStackView.addArrangedSubview(innerStackView2)
        innerStackView1.addArrangedSubview(entireBtn)
        innerStackView1.addArrangedSubview(androidBtn)
        innerStackView1.addArrangedSubview(iOSBtn)
        innerStackView2.addArrangedSubview(frontendBtn)
        innerStackView2.addArrangedSubview(backendBtn)
        innerStackView2.addArrangedSubview(aiBtn)

        innerStackView1.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.width.equalTo(250).priority(500)
        }

        innerStackView2.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.width.equalTo(250).priority(500)
        }

        entireBtn.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.width.equalTo(74)
        }

        androidBtn.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.width.equalTo(97)
        }

        iOSBtn.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.width.equalTo(74)
        }

        frontendBtn.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.width.equalTo(105)
        }

        backendBtn.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.width.equalTo(101)
        }

        aiBtn.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.width.equalTo(62)
        }
    }

    func setUI() {
        entireBtn.setLayer()
        androidBtn.setLayer()
        iOSBtn.setLayer()
        frontendBtn.setLayer()
        backendBtn.setLayer()
        aiBtn.setLayer()
    }
}
