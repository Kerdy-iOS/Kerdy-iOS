//
//  NavigationBarView.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/1/23.
//

import UIKit

import Core
import SnapKit

final class NavigationBarView: UIView {
    
    // MARK: - Property
    
    // MARK: - UI Property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 14)
        label.textColor = .kerdyBlack
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(.backButtonIcon, for: .normal)
        return button
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

// MARK: - Methods

extension NavigationBarView {
    
    private func setLayout() {
        
        self.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        self.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalToSuperview().inset(10)
            $0.size.equalTo(24)

        }
    }
    
    private func setUI() {
        
        self.backgroundColor = .kerdyBackground
    }
    
    func configureUI(to title: String) {
        
        titleLabel.text = title
    }
    
}
