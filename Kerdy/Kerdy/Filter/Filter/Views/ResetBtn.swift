//
//  ResetBtnView.swift
//  Kerdy
//
//  Created by 이동현 on 11/3/23.
//

import UIKit
import SnapKit

final class ResetBtn: UIButton {

    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "전체 초기화"
        label.font = .nanumSquare(to: .bold, size: 12)
        label.textColor = .kerdyGray02
        return label
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
        addSubviews(label)

        label.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.trailing.equalToSuperview().offset(1)
            $0.height.equalTo(14)
        }
    }
    
    private func setUI() {
        setImage(UIImage(named: "ic_reset"), for: .normal)
        contentHorizontalAlignment = .leading
    }
}
