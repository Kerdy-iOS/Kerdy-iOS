//
//  FilterFooterView.swift
//  Kerdy
//
//  Created by 이동현 on 12/17/23.
//

import UIKit
import SnapKit
import Core

final class FilterFooterView: UICollectionReusableView {
    private lazy var divideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)
    static let reuseIdentifier = "filterFooter"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - layout 설정
extension FilterFooterView {
    private func setLayout() {
        addSubview(divideLine)

        divideLine.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}
