//
//  TagFilterView.swift
//  Kerdy
//
//  Created by 이동현 on 11/3/23.
//

import UIKit
import Core
import SnapKit

final class TagFilterView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "태그"
        label.font = .nanumSquare(to: .bold, size: 15)
        return label
    }()

    private lazy var tagView = TechTagView()

    private lazy var divideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)

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
            tagView,
            divideLine
        )

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(17)
            $0.size.width.equalTo(28).priority(250)
            $0.size.height.equalTo(19).priority(250)
        }

        tagView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(17)
            $0.height.equalTo(70).priority(250)
        }

        divideLine.snp.makeConstraints {
            $0.top.equalTo(tagView.snp.bottom).offset(26)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }

    func setUI() {
        tagView.subviews.forEach {
            guard let view = $0 as? FilterBtn else { return }
            view.setLayer()
        }
    }
}
