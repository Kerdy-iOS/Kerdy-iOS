//
//  AuthVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/21/23.
//

import UIKit

import SnapKit
import Alamofire

import RxSwift

final class AuthVC: BaseVC {
    
    // MARK: - Properties
    
    private let viewModel: AuthViewModel
    
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
        return button
    }()
    
    // MARK: - Life Cycle
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

// MARK: - Network

extension AuthVC {
    
    private func bind() {
        let input = AuthViewModel.Input(authButtonDidTap: loginButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        output.didLoginTapped
            .emit(onNext: { _ in
                let initialSettingVC = FirstInitialSettingVC()
                SceneDelegate.shared?.changeRootViewControllerTo(initialSettingVC)
            })
            .disposed(by: disposeBag)
        
    }
}
