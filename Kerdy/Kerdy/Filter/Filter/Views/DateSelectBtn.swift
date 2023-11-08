//
//  DateSelectBtn.swift
//  Kerdy
//
//  Created by 이동현 on 11/6/23.
//

import UIKit
import SnapKit

final class DateSelectBtn: PrortudingBtn {
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = nil
        label.font = .nanumSquare(to: .regular, size: 13)
        return label
    }()

    init() {
        super.init(title: "", titleColor: .black, fontSize: 13, backgroundColor: .white)
        setLayout()
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-22)
        }
    }

    private func setUI() {
        setImage(
            UIImage(named: "ic_calendar_on")?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        tintColor = .kerdyGray01
        contentHorizontalAlignment = .leading
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.imagePadding = 19
        configuration = buttonConfiguration
        setLayer(color: .kerdyGray01)
    }

    func setLayer(color: UIColor) {
        super.setLayer(
            topLeft: 15,
            topRight: 25,
            bottomLeft: 25,
            bottomRight: 15,
            strokeColor: color
        )
    }

}
