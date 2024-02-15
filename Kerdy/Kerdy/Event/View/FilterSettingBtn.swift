//
//  FilterSettingButton.swift
//  Temp
//
//  Created by 이동현 on 11/2/23.
//

import UIKit

final class FilterSettingBtn: UIView {
    // MARK: - UI Property
    lazy var filterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_filter")
        return imageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "필터설정"
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    // MARK: - Initialize
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - layout 설정
extension FilterSettingBtn {
    private func setLayout() {
        addSubview(filterImageView)
        addSubview(label)
        addSubview(button)

        filterImageView.snp.makeConstraints {
            $0.height.equalTo(14)
            $0.width.equalTo(14)
            $0.verticalEdges.leading.equalToSuperview()
        }

        label.snp.makeConstraints {
            $0.height.equalTo(14)
            $0.width.equalTo(44)
            $0.leading.equalTo(filterImageView.snp.trailing).offset(2)
            $0.trailing.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }

        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
