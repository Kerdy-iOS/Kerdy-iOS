//
//  FourthInitialSettingVC.swift
//  Kerdy
//
//  Created by 최다경 on 11/4/23.
//

import UIKit

class FourthInitialSettingVC: UIViewController {
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.text = "4/4"
        label.font = .nanumSquare(to: .regular, size: 14)
        label.textColor = .kerdyMain
        return label
    }()
    
    private lazy var clubActivityLabel: UILabel = {
        let label = UILabel()
        label.text = "동아리 활동"
        label.font = .nanumSquare(to: .regular, size: 14)
        return label
    }()
    
    private lazy var askClubActivityLabel: UILabel = {
        let label = UILabel()
        label.text = "동아리 활동이 있나요?"
        label.font = .nanumSquare(to: .regular, size: 20)
        return label
    }()
    
    private lazy var notifyLabel: UILabel = {
        let label = UILabel()
        label.text = "동아리 활동을 했다면 추가해 주세요."
        label.font = .nanumSquare(to: .regular, size: 13)
        label.textColor = .kerdyGray04
        return label
    }()
    
    private lazy var clubTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "kerdy_gray01")!])
        textField.font = UIFont(name: "NanumSquareR", size: 16)
        textField.borderStyle = .none
        return textField
    }()
    
    private lazy var clubTextFieldUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray01
        return view;
    }()
    
    private lazy var enterLaterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("나중에 입력하기", for: .normal)
        button.setTitleColor(.kerdyGray02, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(enterLaterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var enterLaterButtonUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray02
        return view;
    }()
    
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .nanumSquare(to: .regular, size: 16)
        button.backgroundColor = .kerdyMain
        button.layer.cornerRadius = 15
        button.setTitle("완료", for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setUpUI()
        setLayout()
        setNaviBar()
    }
    
    private func setLayout() {
        self.view.addSubview(progressLabel)
        self.view.addSubview(clubActivityLabel)
        self.view.addSubview(askClubActivityLabel)
        self.view.addSubview(notifyLabel)
        self.view.addSubview(clubTextField)
        self.view.addSubview(clubTextFieldUnderline)
        self.view.addSubview(doneButton)
        self.view.addSubview(enterLaterButton)
        self.view.addSubview(enterLaterButtonUnderline)
        
        progressLabel.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(16)
            make.top.equalToSuperview().offset(97)
            make.leading.equalToSuperview().offset(21)
        }
        
        clubActivityLabel.snp.makeConstraints { make in
            make.width.equalTo(68)
            make.height.equalTo(16)
            make.top.equalToSuperview().offset(121)
            make.leading.equalToSuperview().offset(21)
        }
        
        askClubActivityLabel.snp.makeConstraints { make in
            make.width.equalTo(185)
            make.height.equalTo(23)
            make.top.equalToSuperview().offset(174)
            make.leading.equalToSuperview().offset(21)
        }
        
        notifyLabel.snp.makeConstraints { make in
            make.width.equalTo(194)
            make.height.equalTo(15)
            make.top.equalToSuperview().offset(207)
            make.leading.equalToSuperview().offset(21)
        }
        
        clubTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(257)
            make.leading.equalToSuperview().offset(21)
            make.trailing.equalToSuperview().offset(-21)
        }
        
        clubTextFieldUnderline.snp.makeConstraints { make in
            make.width.equalTo(318)
            make.height.equalTo(1.5)
            make.top.equalToSuperview().offset(285)
            make.leading.equalToSuperview().offset(21)
            make.trailing.equalToSuperview().offset(-21)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.top.equalToSuperview().offset(675)
            make.leading.equalToSuperview().offset(17)
            make.trailing.equalToSuperview().offset(-17)
        }
        
        enterLaterButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(17)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(641)
        }
        
        enterLaterButtonUnderline.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(1.5)
            make.top.equalToSuperview().offset(657)
            make.leading.equalTo(enterLaterButton.snp.leading)
            make.trailing.equalTo(enterLaterButton.snp.trailing)
        }
    }
    
    private func setUpUI() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func setNaviBar() {
        navigationController?.navigationBar.tintColor = .kerdyGray01
        navigationItem.backButtonTitle = ""
    }
    
    @objc private func doneButtonTapped() {
        
        }
    
    @objc private func enterLaterButtonTapped() {
        
        }
    
}
