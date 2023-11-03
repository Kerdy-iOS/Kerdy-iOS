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
        setLayout()
        setUI(title: title, tag: tag)
    }

    private func setLayout() {
        addSubview(label)
        addSubview(underLine)
        addSubview(button)

        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        underLine.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setUI(title: String, tag: Int) {
        label.text = title
        button.tag = tag

        if tag == 0 { setSelected() }
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
