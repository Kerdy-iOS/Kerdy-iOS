//
//  FourthInitialSettingVC.swift
//  Kerdy
//
//  Created by 최다경 on 11/4/23.
//

import UIKit
import Core
import RxSwift

final class FourthInitialSettingVC: UIViewController {
    private let clubViewModel = ClubViewModel()
    private let disposeBag = DisposeBag()
    private var buttons: [UIButton] = []
    
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
    
    private lazy var yappBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(doneButtonTapped(_:)), title: "YAPP")
    
    private lazy var soptBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(doneButtonTapped(_:)), title: "SOPT")
    
    private lazy var gdscBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(doneButtonTapped(_:)), title: "GDSC")
    
    private lazy var mashUpBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(doneButtonTapped(_:)), title: "매쉬업")
    
    private lazy var nextersBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(doneButtonTapped(_:)), title: "NEXTERS")
    
    private lazy var likeLionBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(doneButtonTapped(_:)), title: "멋쟁이 사자처럼")
    
    private lazy var clubStackView1: InitialSettingStackView = InitialSettingStackView()
    
    private lazy var clubStackView2: InitialSettingStackView = InitialSettingStackView()
    
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
        button.backgroundColor = .white
        button.setTitle("나중에 입력하기", for: .normal)
        button.setTitleColor(.kerdyGray02, for: .normal)
        button.titleLabel?.font = .nanumSquare(to: .regular, size: 15)
        button.addTarget(self, action: #selector(enterLaterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var enterLaterButtonUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray02
        return view
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
        setUI()
        setLayout()
        setNaviBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if buttons.isEmpty {
            buttons.append(yappBtn)
            buttons.append(soptBtn)
            buttons.append(gdscBtn)
            buttons.append(mashUpBtn)
            buttons.append(nextersBtn)
            buttons.append(likeLionBtn)
        }
        setButton()
    }
    
    private func setLayout() {
        view.addSubview(progressLabel)
        view.addSubview(clubActivityLabel)
        view.addSubview(askClubActivityLabel)
        view.addSubview(notifyLabel)
        view.addSubview(doneButton)
        view.addSubview(enterLaterButton)
        view.addSubview(enterLaterButtonUnderline)
        setVerticalStackView()
        
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
    
    private func setStackView1() {
        clubStackView1.addArrangedSubview(yappBtn)
        clubStackView1.addArrangedSubview(soptBtn)
        clubStackView1.addArrangedSubview(gdscBtn)
        view.addSubview(clubStackView1)
        
        yappBtn.snp.makeConstraints {
            $0.width.equalTo(70)
        }
        
        soptBtn.snp.makeConstraints {
            $0.width.equalTo(70)
        }
        
        gdscBtn.snp.makeConstraints {
            $0.width.equalTo(70)
        }
    }
    
    private func setStackView2() {
        clubStackView2.addArrangedSubview(mashUpBtn)
        clubStackView2.addArrangedSubview(nextersBtn)
        clubStackView2.addArrangedSubview(likeLionBtn)
        view.addSubview(clubStackView2)
        
        mashUpBtn.snp.makeConstraints {
            $0.width.equalTo(65)
        }
        
        nextersBtn.snp.makeConstraints {
            $0.width.equalTo(90)
        }
        
        likeLionBtn.snp.makeConstraints {
            $0.width.equalTo(110)
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
            
            clubViewModel.clubSelectedDict[button] = BehaviorSubject<Bool>(value: false)
            clubViewModel.clubSelectedDict[button]?.subscribe(onNext: {isSelected in
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
        verticalStackView.addArrangedSubview(clubStackView1)
        verticalStackView.addArrangedSubview(clubStackView2)
        
        view.addSubview(verticalStackView)
        
        verticalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(283)
            $0.leading.equalToSuperview().offset(21)
            $0.trailing.equalToSuperview().offset(-21)
        }
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func setNaviBar() {
        navigationController?.navigationBar.tintColor = .kerdyGray01
        navigationItem.backButtonTitle = ""
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        clubViewModel.clubButtonTapped(button: sender)
            
    }
    
    @objc private func enterLaterButtonTapped() {
        
    }
}
