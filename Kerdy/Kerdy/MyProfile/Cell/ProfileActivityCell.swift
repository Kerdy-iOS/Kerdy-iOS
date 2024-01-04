//
//  ProfileActivityCell.swift
//  Kerdy
//
//  Created by 최다경 on 12/14/23.
//

import UIKit
import SnapKit
import Core

protocol ProfileActivityCellDelegate: AnyObject {
    func addBtnTapped(cell: ProfileActivityCell)
}

final class ProfileActivityCell: UITableViewCell {
    
    weak var delegate: ProfileActivityCellDelegate?
    var labels: [ProfileTagBtn] = []
    var labelOffset = 50
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.font = .nanumSquare(to: .bold, size: 15)
        return label
    }()
    
    let addBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.icAddButton, for: .normal)
        btn.addTarget(self, action: #selector(addBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private let activityImg: UIImageView = {
        let img = UIImageView()
        img.image = .icActivity
        return img
    }()
    
    let divideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    private func setLayout() {
        contentView.addSubview(divideLine)
        contentView.addSubview(activityImg)
        contentView.addSubview(titleLabel)
        contentView.addSubview(addBtn)
        
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

        addBtn.snp.makeConstraints {
            $0.width.equalTo(36)
            $0.height.equalTo(18)
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(7)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addBtnTapped(_ sender: UIButton) {
        delegate?.addBtnTapped(cell: self)
    }

}
