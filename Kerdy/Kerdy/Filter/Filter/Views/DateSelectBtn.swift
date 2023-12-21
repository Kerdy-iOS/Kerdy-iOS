//
//  DateSelectBtn.swift
//  Kerdy
//
//  Created by 이동현 on 11/6/23.
//

import UIKit
import SnapKit

enum DateType {
    case startDate
    case endDate
}

final class DateSelectBtn: PrortudingBtn {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = nil
        label.font = .nanumSquare(to: .regular, size: 13)
        return label
    }()

    let dateType: DateType
    
    init(type: DateType) {
        dateType = type
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
        setLayer()
    }
    
    func setDateString(_ dateString: String?) {
        label.text = dateString
        
        if dateString == nil {
            tintColor = .kerdyGray01
        } else {
            tintColor = .kerdyMain
        }
    }

    func setLayer() {
        
        let layers = self.layer.sublayers
        layers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        if label.text == nil {
            super.setLayer(
                topLeft: 15,
                topRight: 25,
                bottomLeft: 25,
                bottomRight: 15,
                strokeColor: .kerdyGray01
            )
        } else {
            super.setLayer(
                topLeft: 15,
                topRight: 25,
                bottomLeft: 25,
                bottomRight: 15,
                strokeColor: .kerdyMain
            )
        }
    }
}
