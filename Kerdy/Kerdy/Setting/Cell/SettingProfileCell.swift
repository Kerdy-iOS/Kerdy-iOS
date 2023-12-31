//
//  SettingProfileCell.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 10/31/23.
//

import UIKit

import Core
import Kingfisher
import SnapKit

import RxCocoa
import RxSwift

final class SettingProfileCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private struct Const {
        static let cornerRadius: CGFloat = 65/2
        static let idFontSize: CGFloat = 16
        static let idLineSpacing: CGFloat = 18.16
        static let emailFontSize: CGFloat = 12
        static let emailLineSpacing: CGFloat = 13.62
        static let spacing: CGFloat = 4
    }
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let profileButton: UIButton = {
        let button = UIButton()
        button.makeCornerRound(radius: Const.cornerRadius)
        button.makeBorder(width: 0.5, color: .kerdyGray01)
        button.backgroundColor = .clear
        button.tintColor = .clear
        return button
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

    fileprivate lazy var comments: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.kerdyStyle(to: Strings.comments)
        return button
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray01
        return view
    }()
    
    // MARK: - Initialize
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
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
        
        contentView.addSubview(profileButton)
        profileButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.leading.equalToSuperview().inset(17)
            $0.size.equalTo(65)
        }
        
        contentView.addSubview(userId)
        userId.snp.makeConstraints {
            $0.top.equalTo(profileButton.snp.top).offset(13)
            $0.leading.equalTo(profileButton.snp.trailing).offset(12)
        }
        
        contentView.addSubview(userEmail)
        userEmail.snp.makeConstraints {
            $0.top.equalTo(userId.snp.bottom).offset(7)
            $0.leading.equalTo(userId.snp.leading)
        }
        
        contentView.addSubview(comments)
        comments.snp.makeConstraints {
            $0.top.equalTo(profileButton.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(17)
            $0.height.equalTo(36)
        }
        
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    private func setUI() {
        
        self.backgroundColor = .clear
    }
}

// MARK: - Methods

extension SettingProfileCell {
    
    func configureData(to data: MemberProfileResponseDTO) {
        
        userId.text = data.name ?? "KERDY"
        userEmail.text = data.githubURL
        profileButton.kf.setImage(with: URL(string: data.imageURL), for: .normal)
    }
}

// MARK: - Reactive extension

extension Reactive where Base: SettingProfileCell {

    var comment: ControlEvent<Void> {
        base.comments.rx.tap
    }
}
