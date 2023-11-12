//
//  ThirdInitialSettingVC.swift
//  Kerdy
//
//  Created by 최다경 on 11/4/23.
//

import UIKit

final class ThirdInitialSettingVC: UIViewController {
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.text = "3/4"
        label.font = .nanumSquare(to: .regular, size: 14)
        label.textColor = .kerdyMain
        return label
    }()
    
    private lazy var educationLabel: UILabel = {
        let label = UILabel()
        label.text = "교육 활동"
        label.font = .nanumSquare(to: .regular, size: 14)
        return label
    }()
    
    private lazy var educationAskLabel: UILabel = {
        let label = UILabel()
        label.text = "교육 이력이 있나요?"
        label.font = .nanumSquare(to: .regular, size: 20)
        return label
    }()
    
    private lazy var notifyLabel: UILabel = {
        let label = UILabel()
        label.text = "교육받은 활동이 있다면 추가해 주세요."
        label.font = .nanumSquare(to: .regular, size: 13)
        label.textColor = .kerdyGray04
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.kerdyGray01])
        textField.font = .nanumSquare(to: .regular, size: 16)
        textField.borderStyle = .none
        return textField
    }()
    
    private lazy var nameTextFieldUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray01
        return view
    }()
    
    private lazy var enterLaterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("나중에 입력하기", for: .normal)
        button.setTitleColor(.kerdyGray02, for: .normal)
        button.titleLabel?.font = UIFont(name: "NanumSquareR", size: 15)
        button.addTarget(self, action: #selector(enterLaterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var enterLaterButtonUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray02
        return view
    }()

    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .kerdyMain
        button.layer.cornerRadius = 15
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .nanumSquare(to: .regular, size: 16)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setLayout()
        setNaviBar()
    }
    
    private func setLayout() {
        view.addSubview(progressLabel)
        view.addSubview(educationLabel)
        view.addSubview(educationAskLabel)
        view.addSubview(notifyLabel)
        view.addSubview(nameTextField)
        view.addSubview(nameTextFieldUnderline)
        view.addSubview(nextButton)
        view.addSubview(enterLaterButton)
        view.addSubview(enterLaterButtonUnderline)
        
        progressLabel.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(16)
            $0.top.equalToSuperview().offset(97)
            $0.leading.equalToSuperview().offset(21)
        }
        
        educationLabel.snp.makeConstraints {
            $0.width.equalTo(55)
            $0.height.equalTo(16)
            $0.top.equalToSuperview().offset(121)
            $0.leading.equalToSuperview().offset(21)
        }
        
        educationAskLabel.snp.makeConstraints {
            $0.width.equalTo(167)
            $0.height.equalTo(23)
            $0.top.equalToSuperview().offset(174)
            $0.leading.equalToSuperview().offset(21)
        }
        
        notifyLabel.snp.makeConstraints {
            $0.width.equalTo(206)
            $0.height.equalTo(15)
            $0.top.equalToSuperview().offset(207)
            $0.leading.equalToSuperview().offset(21)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(257)
            $0.leading.equalToSuperview().offset(21)
            $0.trailing.equalToSuperview().offset(-21)
        }
        
        nameTextFieldUnderline.snp.makeConstraints {
            $0.width.equalTo(318)
            $0.height.equalTo(1.5)
            $0.top.equalToSuperview().offset(285)
            $0.leading.equalToSuperview().offset(21)
            $0.trailing.equalToSuperview().offset(-21)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalToSuperview().offset(675)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-17)
        }
        
        enterLaterButton.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(17)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(641)
        }
        
        enterLaterButtonUnderline.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(1.5)
            $0.top.equalToSuperview().offset(657)
            $0.leading.equalTo(enterLaterButton.snp.leading)
            $0.trailing.equalTo(enterLaterButton.snp.trailing)
        }

    }
    
    private func setUpUI() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func setNaviBar() {
        navigationController?.navigationBar.tintColor = .kerdyGray01
        navigationItem.backButtonTitle = ""
    }
    
    @objc private func nextButtonTapped() {
        let nextVC = FourthInitialSettingVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func enterLaterButtonTapped() {
        let nextVC = FourthInitialSettingVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
