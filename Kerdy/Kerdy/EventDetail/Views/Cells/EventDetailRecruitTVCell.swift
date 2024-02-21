//
//  EventDetailRecruitTVCell.swift
//  Kerdy
//
//  Created by 이동현 on 1/5/24.
//

import UIKit

final class EventDetailRecruitTVCell: UITableViewCell {
    // MARK: - UI Property
    private lazy var memberNameLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 13)
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 13)
        label.textColor = .kerdyGray03
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 11)
        label.textColor = .kerdyGray02
        return label
    }()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell configuration
    func configure(with recruitment: RecruitmentResponseDTO) {
        memberNameLabel.text = recruitment.member.name
        contentLabel.text = recruitment.content
        timeLabel.text = recruitment.updatedAt
    }
}

// MARK: - layout 설정
extension EventDetailRecruitTVCell {
    private func setLayout() {
        addSubviews(
            memberNameLabel,
            contentLabel,
            timeLabel
        )
        
        memberNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(17)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(memberNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(memberNameLabel.snp.leading)
            $0.width.equalTo(210).priority(500)
            $0.height.equalTo(30).priority(500)
        }
    
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.leading.equalTo(memberNameLabel.snp.trailing).offset(5)
            $0.width.equalTo(10).offset(500)
            $0.height.equalTo(12)
        }
    }
}
