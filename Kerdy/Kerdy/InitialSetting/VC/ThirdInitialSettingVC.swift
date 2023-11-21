//
//  ThirdInitialSettingVC.swift
//  Kerdy
//
//  Created by 최다경 on 11/4/23.
//

import UIKit
import Core
import RxSwift
import SnapKit

final class ThirdInitialSettingVC: UIViewController {
    private let educationViewModel = EducationViewModel()
    private let disposeBag = DisposeBag()
    private var buttons: [UIButton] = []
    
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
    
    private lazy var woowaBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(educationButtonTapped(_:)), title: "우아한테크코스")
    
    private lazy var swBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(educationButtonTapped(_:)), title: "sw 마에스트로")
    
    private lazy var nextersBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(educationButtonTapped(_:)), title: "NEXTERS")
    
    private lazy var seoulBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(educationButtonTapped(_:)), title: "42 서울")
    
    private lazy var ssafyBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(educationButtonTapped(_:)), title: "SAFFY")
    
    private lazy var boostCampBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(educationButtonTapped(_:)), title: "부스트캠프")
    
    private lazy var educationStackView1: InitialSettingStackView = InitialSettingStackView()
    
    private lazy var educationStackView2: InitialSettingStackView = InitialSettingStackView()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 11
        return stackView
    }()
    
    private lazy var enterLaterButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "NanumSquareR", size: 15)
        button.backgroundColor = .clear
        button.setTitle("나중에 입력하기", for: .normal)
        button.setTitleColor(.kerdyGray02, for: .normal)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if buttons.isEmpty {
            buttons.append(woowaBtn)
            buttons.append(swBtn)
            buttons.append(nextersBtn)
            buttons.append(seoulBtn)
            buttons.append(ssafyBtn)
            buttons.append(boostCampBtn)
        }
        setButton()
    }
    
    private func setLayout() {
        view.addSubviews(progressLabel, educationLabel, educationAskLabel, notifyLabel, nextButton, enterLaterButton, enterLaterButtonUnderline)
        
        setVerticalStackView()
        
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
    
    private func setStackView1() {
        educationStackView1.addArrangedSubview(woowaBtn)
        educationStackView1.addArrangedSubview(swBtn)
        educationStackView1.addArrangedSubview(nextersBtn)
        view.addSubview(educationStackView1)
        
        woowaBtn.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        
        swBtn.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        
        nextersBtn.snp.makeConstraints {
            $0.width.equalTo(80)
        }
    }
    
    private func setStackView2() {
        educationStackView2.addArrangedSubview(seoulBtn)
        educationStackView2.addArrangedSubview(ssafyBtn)
        educationStackView2.addArrangedSubview(boostCampBtn)
        view.addSubview(educationStackView2)
        
        seoulBtn.snp.makeConstraints {
            $0.width.equalTo(80)
        }
        
        ssafyBtn.snp.makeConstraints {
            $0.width.equalTo(80)
        }
        
        boostCampBtn.snp.makeConstraints {
            $0.width.equalTo(100)
        }
    }
    
    private func setButton() {
        for button in buttons {
            button.roundCorners(topLeft: 10, topRight: 20, bottomLeft: 20, bottomRight: 10)
            let borderLayer = CAShapeLayer()
            guard let buttonMaskLayer = button.layer.mask as? CAShapeLayer else {
                continue
            }
            borderLayer.path = buttonMaskLayer.path
            borderLayer.strokeColor = UIColor(named: "kerdy_main")?.cgColor
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.lineWidth = 3
            borderLayer.frame = button.bounds
            button.layer.addSublayer(borderLayer)
            button.titleLabel?.font = .nanumSquare(to: .regular, size: 13)
            
            educationViewModel.educationSelectedDict[button] = BehaviorSubject<Bool>(value: false)
            educationViewModel.educationSelectedDict[button]?.subscribe(onNext: {isSelected in
                button.backgroundColor = isSelected ? .kerdyMain : .white
            }).disposed(by: disposeBag)
            
            button.snp.makeConstraints {
                $0.height.equalTo(32)
            }
        }
    }
    
    private func setVerticalStackView() {
        setStackView1()
        setStackView2()
        verticalStackView.addArrangedSubview(educationStackView1)
        verticalStackView.addArrangedSubview(educationStackView2)
        
        view.addSubview(verticalStackView)
        
        verticalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(283)
            $0.leading.equalToSuperview().offset(21)
            $0.trailing.equalToSuperview().offset(-21)
        }
    }
     
    private func setUpUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func setNaviBar() {
        navigationController?.navigationBar.tintColor = .kerdyGray01
        navigationItem.backButtonTitle = ""
    }
    
    @objc private func educationButtonTapped(_ sender: UIButton) {
        educationViewModel.educationButtonTapped(button: sender)
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
