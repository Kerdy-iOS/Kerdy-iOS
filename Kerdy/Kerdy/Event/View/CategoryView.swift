//
//  CategoryView.swift
//  Kerdy
//
//  Created by 이동현 on 2023/10/28.
//

import UIKit
import SnapKit

final class CategoryView: UIView {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 14)
        return label
    }()

    private lazy var underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray01
        return view
    }()

    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle(nil, for: .normal)
        return button
    }()

    init(title: String, tag: Int) {
        super.init(frame: .zero)
        label.text = title
        button.tag = tag

        if tag == 0 { setSelected() }

        addSubview(label)
        addSubview(underLine)
        addSubview(button)
        makeConstraint()
    }

    private func makeConstraint() {
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        underLine.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        button.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func setSelected() {
        underLine.backgroundColor = .kerdyMain
        label.textColor = .kerdyMain
    }

    func setUnselected() {
        underLine.backgroundColor = .kerdyGray01
        label.textColor = .black
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
