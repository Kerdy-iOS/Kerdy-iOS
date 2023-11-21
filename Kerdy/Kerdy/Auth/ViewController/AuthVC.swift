//
//  AuthVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/21/23.
//

import UIKit

import SnapKit


final class AuthVC: BaseVC {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let logo: UIImageView = {
        let view = UIImageView()
        view.image = .logoIcon
        return view
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .kerdyGray05
        config.baseForegroundColor = .kerdyBackground
        config.background.cornerRadius = 15
        config.image = .githubIcon
        config.imagePadding = 11
        config.attributedTitle =  AttributedString(Strings.login,
                                                   attributes: AttributeContainer([.font: UIFont.nanumSquare(to: .regular, size: 14)]))
        button.configuration = config
        button.addAction(UIAction {_ in
            self.buttonTapped()
        }, for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
    }

}

// MARK: - Setting

extension AuthVC {
    
    private func setLayout() {
        
        view.addSubview(logo)
        logo.snp.makeConstraints {
            $0.center.equalTo(safeArea)
            $0.size.equalTo(CGSize(width: 50, height: 60))
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea).inset(42)
            $0.height.equalTo(63)
            $0.horizontalEdges.equalTo(safeArea).inset(40)
        }
        
    }
    
    private func setUI() {
        let layer = CAGradientLayer(topColor: UIColor.kerdyAuthTop,
                                    bottomColor: UIColor.kerdyAuthBottom,
                                    view: self.view)
        
        view.layer.addSublayer(layer)
    }
}

extension AuthVC {
    
    private func buttonTapped() {
        AuthAPI.shared.requestCode()
    }
}
