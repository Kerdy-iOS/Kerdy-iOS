//
//  EventTableViewCell.swift
//  Temp
//
//  Created by 이동현 on 10/29/23.
//

import UIKit
import SnapKit

final class EventTableViewCell: UITableViewCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 14)
        label.numberOfLines = 3
        return label
    }()

    lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 12)
        return label
    }()

    lazy var tagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        return stackView
    }()

//    lazy var androidTag: TagView

    lazy var eventImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .kerdyGray01
        imageView.layer.cornerRadius = 15
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        contentView.addSubview(tagStackView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(progressLabel)
        contentView.addSubview(eventImage)

        tagStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(17)
            $0.top.equalToSuperview().offset(26)
            $0.height.equalTo(22)
            $0.width.equalTo(194).priority(250)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(17)
            $0.top.equalTo(tagStackView.snp.bottom).offset(12)
            $0.height.equalTo(36).priority(250)
            $0.width.equalTo(177)
        }

        progressLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(17)
            $0.bottom.equalToSuperview().offset(16)
            $0.height.equalTo(33)
        }

        eventImage.snp.makeConstraints {
            $0.height.equalTo(126)
            $0.width.equalTo(100)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-17)
        }
    }

    private func setUpTag() {
        contentView.addSubview(tagStackView)
        for index in 0...2 {
            tagStackView.addArrangedSubview(TagView())
            tagStackView.arrangedSubviews[index].isHidden = true
        }

        tagStackView.snp.makeConstraints { make in
            make.width.equalTo(10).priority(250)
        }
    }
}
