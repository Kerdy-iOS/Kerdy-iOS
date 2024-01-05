//
//  RecentKeywordTableViewCell.swift
//  Kerdy
//
//  Created by 이동현 on 12/22/23.
//

import UIKit

final class RecentKeywordTableViewCell: UITableViewCell {
    private lazy var keywordLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 13)
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.setImage(.cancelIcon, for: .normal)
        return button
    }()
    
    weak var delegate: DataTransferDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        setUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setLayout()
        setUI()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        deleteButton.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside
        )
    }
    
    func configure(keyword: String) {
        keywordLabel.text = keyword
    }
    
    func getText() -> String? {
        return keywordLabel.text
    }
    
    @objc private func deleteBtnTapped() {
        guard let keyword = keywordLabel.text else { return }
        delegate?.dataTransfered(data: keyword)
    }
}

// MARK: - layout 설정
extension RecentKeywordTableViewCell {
    private func setLayout() {
        contentView.addSubviews(
            keywordLabel,
            deleteButton
        )
        
        keywordLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(17)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(10).priority(500)
            $0.height.equalTo(15)
        }
        
        deleteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-17)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(11)
        }
    }
}
