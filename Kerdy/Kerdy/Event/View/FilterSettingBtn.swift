//
//  FilterSettingButton.swift
//  Temp
//
//  Created by 이동현 on 11/2/23.
//

import UIKit

final class FilterSettingBtn: UIView {
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

    init() {
        super.init(frame: .zero)

        addSubview(filterImageView)
        addSubview(label)
        addSubview(button)

        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        filterImageView.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.width.equalTo(14)
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        label.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.width.equalTo(44)
            make.leading.equalTo(filterImageView.snp.trailing).offset(2)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        button.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
