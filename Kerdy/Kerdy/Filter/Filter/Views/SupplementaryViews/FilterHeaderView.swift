//
//  FilterHeaderView.swift
//  Kerdy
//
//  Created by 이동현 on 12/17/23.
//

import UIKit
import SnapKit

final class FilterHeaderView: UICollectionReusableView {
    private lazy var label = UILabel()
    static let reuseIdentifier = "filterHeader"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(title: String) {
        label.text = title
    }
}

// MARK: - layout 설정
extension FilterHeaderView {
    private func setLayout() {
        addSubview(label)
        
        label.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview()
            $0.height.equalTo(19)
        }
    }
}
