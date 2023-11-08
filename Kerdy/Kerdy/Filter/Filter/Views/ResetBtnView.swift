//
//  ResetBtnView.swift
//  Kerdy
//
//  Created by 이동현 on 11/3/23.
//

import UIKit
import SnapKit

class ResetBtnView: UIView {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_reset")
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "전체 초기화"
        label.font = .nanumSquare(to: .bold, size: 12)
        label.textColor = .kerdyGray02
        return label
    }()

    private lazy var resetBtn: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.backgroundColor = .clear
        return button
    }()

    init() {
        super.init(frame: .zero)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        addSubviews(imageView)
        addSubviews(titleLabel)
        addSubviews(resetBtn)

        imageView.snp.makeConstraints {
            $0.size.equalTo(12)
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).offset(1)
            $0.height.equalTo(14)
        }

        resetBtn.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
