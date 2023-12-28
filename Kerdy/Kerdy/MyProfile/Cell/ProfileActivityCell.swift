//
//  ProfileActivityCell.swift
//  Kerdy
//
//  Created by 최다경 on 12/14/23.
//

import UIKit
import SnapKit
import Core

class ProfileActivityCell: UITableViewCell {
    
    var labels: [UILabel] = []
    var labelOffset = 50
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.font = .nanumSquare(to: .bold, size: 15)
        return label
    }()
    
    let activityImg: UIImageView = {
        let img = UIImageView()
        img.image = .icActivity
        return img
    }()
    
    let divideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        labelOffset = 50
        contentView.addSubview(divideLine)
        contentView.addSubview(activityImg)
        contentView.addSubview(titleLabel)
        
        divideLine.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.width.equalTo(0.3)
            $0.leading.equalToSuperview().offset(32)
        }
        
        activityImg.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(17)
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalTo(activityImg.snp.trailing).offset(10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
