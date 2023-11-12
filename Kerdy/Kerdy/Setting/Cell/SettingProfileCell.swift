//
//  SettingProfileCell.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 10/31/23.
//

import UIKit

import SnapKit
import Core

protocol SettingProfileCellDelegate: AnyObject {
    
    func didSelectButton(type: WrittenSections)
}

final class SettingProfileCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var delegate: SettingProfileCellDelegate?
    
    private struct Const {
        static let cornerRadius: CGFloat = 65/2
        static let idFontSize: CGFloat = 16
        static let idLineSpacing: CGFloat = 18.16
        static let emailFontSize: CGFloat = 12
        static let emailLineSpacing: CGFloat = 13.62
        static let spacing: CGFloat = 4
    }
    
    // MARK: - UI Components
    
    private let profile: UIImageView = {
        let image = UIImageView()
        image.makeCornerRound(radius: Const.cornerRadius)
        image.backgroundColor = .kerdyMain
        image.tintColor = .clear
        return image
    }()
    
    private let userId: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: Const.idFontSize)
        label.setLineSpacing(lineSpacing: Const.idLineSpacing)
        label.textColor = .kerdyBlack
        return label
    }()
    
    private let userEmail: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: Const.emailFontSize)
        label.setLineSpacing(lineSpacing: Const.emailLineSpacing)
        label.textColor = .kerdyGray03
        return label
    }()
    
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Const.spacing
        return stackView
    }()
    
    private lazy var article: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.kerdyStyle(to: Strings.article)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.delegate?.didSelectButton(type: .article)
            
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var comments: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.kerdyStyle(to: Strings.comments)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.delegate?.didSelectButton(type: .comment)
            
        }), for: .touchUpInside)
        return button
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray01
        return view
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

extension SettingProfileCell {
    
    private func setLayout() {
        
        contentView.addSubview(profile)
        profile.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.leading.equalToSuperview().inset(17)
            $0.size.equalTo(65)
        }
        
        contentView.addSubview(userId)
        userId.snp.makeConstraints {
            $0.top.equalTo(profile.snp.top).offset(13)
            $0.leading.equalTo(profile.snp.trailing).offset(12)
        }
        
        contentView.addSubview(userEmail)
        userEmail.snp.makeConstraints {
            $0.top.equalTo(userId.snp.bottom).offset(7)
            $0.leading.equalTo(userId.snp.leading)
        }
        
        contentView.addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.top.equalTo(profile.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(17)
            $0.height.equalTo(36)
        }
        
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        hStackView.addArrangedSubviews(article, comments)
    }
    
    private func setUI() {
        
        self.backgroundColor = .clear
        
    }
    
}

// MARK: - Methods

extension SettingProfileCell {
    
    func configureData(to data: ProfileResponseDTO) {
        
        userId.text = data.id
        userEmail.text = data.email
    }
}
