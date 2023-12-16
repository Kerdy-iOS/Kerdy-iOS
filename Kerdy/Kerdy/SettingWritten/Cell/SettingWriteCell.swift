//
//  SettingWriteCell.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/10/23.
//

import UIKit

import Core
import SnapKit

final class SettingWriteCell: UICollectionViewCell {
    
    // MARK: - Property
    
    // MARK: - UI Components
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 13)
        label.textColor = .kerdyBlack
        label.numberOfLines = 1
        label.setLineSpacing(lineSpacing: 1.15)
        return label
    }()
    
    private let content: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 12)
        label.textColor = .kerdyBlack
        label.numberOfLines = 0
        label.setLineSpacing(lineSpacing: 1.19)
        return label
    }()
    
    private let otherStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        return view
    }()
    
    private let comment: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 11)
        label.textColor = .kerdyMain
        return label
    }()
    
    private let date: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 11)
        label.textColor = .kerdyGray02
        return label
    }()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setLayout()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Setting

extension SettingWriteCell {
    
    private func setLayout() {
        
        contentView.addSubview(title)
        title.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview().inset(17)
        }
        
        contentView.addSubview(content)
        content.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview().inset(17)
        }
        
        contentView.addSubview(otherStackView)
        otherStackView.snp.makeConstraints {
            $0.top.equalTo(content.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(17)
            $0.bottom.equalToSuperview().inset(17)
        }
    }
    
    private func setUI() {
        
        contentView.backgroundColor = .clear
        
    }
    
}

// MARK: - Methods

extension SettingWriteCell {
    
    func configureUI<T: SettingWrittenProtocol>(type: WrittenSections, to data: T, count: Int = 0) {
        switch type {
        case .comment:
            otherStackView.addArrangedSubviews(comment, date)
            comment.text = "댓글 " + String(describing: count)
        case .article:
            otherStackView.addArrangedSubview(date)
        }
        
        title.text = data.title
        content.text = data.content
        content.setLineSpacing(lineSpacing: 1.19)
        date.text = data.updateDate
    }
    
}
