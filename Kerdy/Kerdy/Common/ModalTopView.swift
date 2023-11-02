//
//  ModalTopView.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/1/23.
//

import UIKit

import Core
import SnapKit

protocol ButtonActionProtocol {
    
    func cancelButtonTapped()
}

final class ModalTopView: UIView {
    
    // MAKR: = Property
    
    private struct Const {
        static let height = 56
        static let buttonSize = 24
    }
    
    // MAKR: - UI Property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 14)
        label.textColor = .kerdyBlack
        label.textAlignment = .center
        label.setLineSpacing(lineSpacing: 1.15)
        return label
        
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(.cancelIcon, for: .normal)
        return button
        
    }()
    
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

extension ModalTopView {
    
    private func setLayout() {
        
        self.snp.makeConstraints {
            $0.height.equalTo(Const.height)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        self.addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            $0.size.equalTo(Const.buttonSize)
        }
    }
    
    private func setUI() {
        self.backgroundColor = .kerdyBackground
    }
    
    func configureUI(to title: String) {
        titleLabel.text = title
    
    }
}
