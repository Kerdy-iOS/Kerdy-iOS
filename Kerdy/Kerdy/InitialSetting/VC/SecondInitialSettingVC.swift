//
//  SecondInitialSettingVC.swift
//  Kerdy
//
//  Created by 최다경 on 11/3/23.
//

import UIKit
import Core
import RxSwift

final class SecondInitialSettingVC: UIViewController {
    private let categoryViewModel = CategoryViewModel()
    private let disposeBag = DisposeBag()
    private var buttons: [UIButton] = []
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.text = "2/4"
        label.font = .nanumSquare(to: .regular, size: 14)
        label.textColor = .kerdyMain
        return label
    }()
    
    private lazy var interestingPartLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 분야"
        label.font = .nanumSquare(to: .regular, size: 14)
        return label
    }()
    
    private lazy var interestingCategoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "관심 있는 카테고리를\n선택해주세요."
        label.font = .nanumSquare(to: .regular, size: 20)
        return label
    }()
    
    private lazy var notifyLabel: UILabel = {
        let label = UILabel()
        label.text = "복수 선택이 최대 4개까지 가능합니다"
        label.font = .nanumSquare(to: .regular, size: 13)
        label.textColor = .kerdyGray04
        return label
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
    
    private lazy var javaBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(categoryButtonTapped(_:)), title: "Java")
    
    private lazy var springBootBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(categoryButtonTapped(_:)), title: "SpringBoot")
    
    private lazy var awsBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(categoryButtonTapped(_:)), title: "AWS")
    
    private lazy var mySQLBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(categoryButtonTapped(_:)), title: "MySQL")
    
    private lazy var sqlBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(categoryButtonTapped(_:)), title: "SQL")
    
    private lazy var javascriptBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(categoryButtonTapped(_:)), title: "Javascript")
    
    private lazy var githubBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(categoryButtonTapped(_:)), title: "Github")
    
    private lazy var springBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(categoryButtonTapped(_:)), title: "Spring")
    
    private lazy var pythonBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(categoryButtonTapped(_:)), title: "Python")
    
    private lazy var dataAnalysisBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(categoryButtonTapped(_:)), title: "데이터 분석")
    
    private lazy var gitBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(categoryButtonTapped(_:)), title: "Git")
    
    private lazy var dockerBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(categoryButtonTapped(_:)), title: "Docker")
    
    private lazy var communicationBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(categoryButtonTapped(_:)), title: "커뮤니케이션")
    
    private lazy var typescriptBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(categoryButtonTapped(_:)), title: "Typescript")
    
    private lazy var reactBtn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(categoryButtonTapped(_:)), title: "React")
    
    private lazy var categoryStackView1: InitialSettingStackView = InitialSettingStackView()
    
    private lazy var categoryStackView2: InitialSettingStackView = InitialSettingStackView()
    
    private lazy var categoryStackView3: InitialSettingStackView = InitialSettingStackView()
    
    private lazy var categoryStackView4: InitialSettingStackView = InitialSettingStackView()
    
    private lazy var categoryStackView5: InitialSettingStackView = InitialSettingStackView()
    
    private lazy var categoryStackView6: InitialSettingStackView = InitialSettingStackView()

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 11
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setUI()
        setLayout()
        setNaviBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if buttons.isEmpty {
            buttons.append(javaBtn)
            buttons.append(springBootBtn)
            buttons.append(awsBtn)
            buttons.append(mySQLBtn)
            buttons.append(sqlBtn)
            buttons.append(javascriptBtn)
            buttons.append(githubBtn)
            buttons.append(springBtn)
            buttons.append(pythonBtn)
            buttons.append(dataAnalysisBtn)
            buttons.append(gitBtn)
            buttons.append(dockerBtn)
            buttons.append(communicationBtn)
            buttons.append(typescriptBtn)
            buttons.append(reactBtn)
        }
        setButton()
    }
    
    private func setLayout() {
        view.addSubview(progressLabel)
        view.addSubview(interestingPartLabel)
        view.addSubview(interestingCategoryLabel)
        view.addSubview(notifyLabel)
        view.addSubview(nextButton)
        setVerticalStackView()
        
        progressLabel.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(16)
            $0.top.equalToSuperview().offset(97)
            $0.leading.equalToSuperview().offset(21)
        }
        
        interestingPartLabel.snp.makeConstraints {
            $0.width.equalTo(55)
            $0.height.equalTo(16)
            $0.top.equalToSuperview().offset(121)
            $0.leading.equalToSuperview().offset(21)
        }
        
        interestingCategoryLabel.snp.makeConstraints {
            $0.width.equalTo(174)
            $0.height.equalTo(50)
            $0.top.equalToSuperview().offset(174)
            $0.leading.equalToSuperview().offset(21)
        }
        
        notifyLabel.snp.makeConstraints {
            $0.width.equalTo(202)
            $0.height.equalTo(15)
            $0.top.equalToSuperview().offset(234)
            $0.leading.equalToSuperview().offset(21)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalToSuperview().offset(675)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-17)
        }
    }
    
    private func setNaviBar() {
        navigationController?.navigationBar.tintColor = .kerdyGray01
        navigationItem.backButtonTitle = ""
    }
    
    private func setStackView1() {
        categoryStackView1.addArrangedSubview(javaBtn)
        categoryStackView1.addArrangedSubview(springBootBtn)
        categoryStackView1.addArrangedSubview(awsBtn)
        view.addSubview(categoryStackView1)
        
        javaBtn.snp.makeConstraints {
            $0.width.equalTo(77)
        }
        
        springBootBtn.snp.makeConstraints {
            $0.width.equalTo(117)
        }
        
        awsBtn.snp.makeConstraints {
            $0.width.equalTo(79)
        }
    }
    
    private func setStackView2() {
        categoryStackView2.addArrangedSubview(mySQLBtn)
        categoryStackView2.addArrangedSubview(sqlBtn)
        categoryStackView2.addArrangedSubview(javascriptBtn)
        view.addSubview(categoryStackView2)
        
        mySQLBtn.snp.makeConstraints {
            $0.width.equalTo(92)
        }
        
        sqlBtn.snp.makeConstraints {
            $0.width.equalTo(74)
        }
        
        javascriptBtn.snp.makeConstraints {
            $0.width.equalTo(110)
        }
    }
    
    private func setStackView3() {
        categoryStackView3.addArrangedSubview(githubBtn)
        categoryStackView3.addArrangedSubview(springBtn)
        categoryStackView3.addArrangedSubview(pythonBtn)
        view.addSubview(categoryStackView3)
        
        githubBtn.snp.makeConstraints {
            $0.width.equalTo(90)
        }
        
        springBtn.snp.makeConstraints {
            $0.width.equalTo(89)
        }
        
        pythonBtn.snp.makeConstraints {
            $0.width.equalTo(92)
        }
    }
    
    private func setStackView4() {
        categoryStackView4.addArrangedSubview(dataAnalysisBtn)
        categoryStackView4.addArrangedSubview(gitBtn)
        categoryStackView4.addArrangedSubview(dockerBtn)
        view.addSubview(categoryStackView4)
        
        dataAnalysisBtn.snp.makeConstraints {
            $0.width.equalTo(113)
        }
        
        gitBtn.snp.makeConstraints {
            $0.width.equalTo(67)
        }
        
        dockerBtn.snp.makeConstraints {
            $0.width.equalTo(92)
        }
    }
    
    private func setStackView5() {
        categoryStackView5.addArrangedSubview(communicationBtn)
        categoryStackView5.addArrangedSubview(typescriptBtn)
        view.addSubview(categoryStackView5)
        
        communicationBtn.snp.makeConstraints {
            $0.width.equalTo(121)
        }
        
        typescriptBtn.snp.makeConstraints {
            $0.width.equalTo(110)
        }
    }
    
    private func setStackView6() {
        categoryStackView6.addArrangedSubview(reactBtn)
        view.addSubview(categoryStackView6)
        reactBtn.snp.makeConstraints {
            $0.width.equalTo(84)
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
            
            categoryViewModel.categorySelectedDict[button] = BehaviorSubject<Bool>(value: false)
            categoryViewModel.categorySelectedDict[button]?.subscribe(onNext: {isSelected in
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
        setStackView3()
        setStackView4()
        setStackView5()
        setStackView6()
        verticalStackView.addArrangedSubview(categoryStackView1)
        verticalStackView.addArrangedSubview(categoryStackView2)
        verticalStackView.addArrangedSubview(categoryStackView3)
        verticalStackView.addArrangedSubview(categoryStackView4)
        verticalStackView.addArrangedSubview(categoryStackView5)
        verticalStackView.addArrangedSubview(categoryStackView6)
        
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
    
    @objc private func nextButtonTapped() {
        let nextViewController = ThirdInitialSettingVC()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        categoryViewModel.categoryButtonTapped(button: sender)
    }
}
