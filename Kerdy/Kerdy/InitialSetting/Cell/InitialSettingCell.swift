//
//  EducationCell.swift
//  Kerdy
//
//  Created by 최다경 on 11/23/23.
//

import UIKit
import SnapKit

class InitialSettingCell: UITableViewCell {
    
    let buttonStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.alignment = .fill
            stackView.spacing = 8
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5.5)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5.5)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
