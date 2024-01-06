//
//  FirstInitialSettingVC.swift
//  Kerdy
//
//  Created by 최다경 on 11/3/23.
//

import UIKit
import SnapKit

final class FirstInitialSettingVC: UIViewController {
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.text = "1/4"
        label.font = .nanumSquare(to: .regular, size: 14)
        label.textColor = .kerdyMain
        return label
    }()
    
    private lazy var nameSettingLabel: UILabel = {
        let label = UILabel()
        label.text = "이름 설정"
        label.font = .nanumSquare(to: .regular, size: 14)
        return label
    }()
    
    private lazy var nameAskLabel: UILabel = {
        let label = UILabel()
        label.text = "이름이 무엇인가요?"
        label.font = .nanumSquare(to: .regular, size: 20)
        return label
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = "설정 시 변경이 불가합니다."
        label.font = .nanumSquare(to: .regular, size: 13)
        label.textColor = .kerdyGray04
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.kerdyGray01])
        textField.font = .nanumSquare(to: .regular, size: 16)
        textField.borderStyle = .none
        return textField
    }()
    
    private lazy var contourLine: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray01
        return view
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .nanumSquare(to: .regular, size: 16)
        button.backgroundColor = .kerdyMain
        button.layer.cornerRadius = 15
        button.setTitle("다음", for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setNaviBar()
    }

    private func setLayout() {
        view.addSubviews(progressLabel, nameSettingLabel, nameAskLabel, warningLabel, nameTextField, contourLine, nextButton)
        
        progressLabel.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(16)
            $0.top.equalToSuperview().offset(97)
            $0.leading.equalToSuperview().offset(21)
        }
        
        nameSettingLabel.snp.makeConstraints {
            $0.width.equalTo(55)
            $0.height.equalTo(16)
            $0.top.equalToSuperview().offset(121)
            $0.leading.equalToSuperview().offset(21)
        }
        
        nameAskLabel.snp.makeConstraints {
            $0.width.equalTo(162)
            $0.height.equalTo(23)
            $0.top.equalToSuperview().offset(174)
            $0.leading.equalToSuperview().offset(21)
        }
        
        warningLabel.snp.makeConstraints {
            $0.width.equalTo(144)
            $0.height.equalTo(15)
            $0.top.equalToSuperview().offset(207)
            $0.leading.equalToSuperview().offset(21)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(257)
            $0.leading.equalToSuperview().offset(21)
            $0.trailing.equalToSuperview().offset(21)
        }
        
        contourLine.snp.makeConstraints {
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
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func setNaviBar() {
        navigationController?.navigationBar.tintColor = .kerdyGray01
        navigationItem.backButtonTitle = ""
    }

    @objc private func nextButtonTapped() {
        let nextViewController = SecondInitialSettingVC()
        if let name = nameTextField.text, !name.isEmpty {
            nextViewController.memberInfo.name = name
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }

}
