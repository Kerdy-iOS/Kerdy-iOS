//
//  ItemCountView.swift
//  Kerdy
//
//  Created by 이동현 on 2023/10/28.
//

import UIKit

final class ItemCountView: UIView {
    // MARK: - UI Property
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
    
    // MARK: - Initialize
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    func setCount(count: Int) {
        countLabel.text = String(count)
    }
}

// MARK: - layout 설정
extension ItemCountView {
    private func setLayout() {
        addSubview(startLabel)
        addSubview(countLabel)
        addSubview(endLabel)

        startLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        countLabel.snp.makeConstraints {
            $0.leading.equalTo(startLabel.snp.trailing).offset(1)
            $0.verticalEdges.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        endLabel.snp.makeConstraints {
            $0.leading.equalTo(countLabel.snp.trailing).offset(1)
            $0.verticalEdges.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
