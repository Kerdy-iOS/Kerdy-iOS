//
//  ItemCountView.swift
//  Kerdy
//
//  Created by 이동현 on 2023/10/28.
//

import UIKit

final class ItemCountView: UIView {
    private lazy var startLabel: UILabel = {
        let label = UILabel()
        label.text = "총"
        label.font = .nanumSquare(to: .bold, size: 12)
        return label
    }()

    private lazy var endLabel: UILabel = {
        let label = UILabel()
        label.text = "개"
        label.font = .nanumSquare(to: .bold, size: 12)
        return label
    }()

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .nanumSquare(to: .bold, size: 12)
        label.textColor = .kerdyMain
        return label
    }()

    init() {
        super.init(frame: .zero)

        addSubview(startLabel)
        addSubview(countLabel)
        addSubview(endLabel)
        makeConstraint()
    }

    private func makeConstraint() {
        startLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(14)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(startLabel.snp.trailing).offset(1)
            make.height.equalTo(14)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        endLabel.snp.makeConstraints { make in
            make.leading.equalTo(countLabel.snp.trailing)
            make.height.equalTo(14)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    func setCount(count: Int) {
        countLabel.text = String(count)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
