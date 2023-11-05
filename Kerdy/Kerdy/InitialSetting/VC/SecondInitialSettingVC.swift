//
//  SecondInitialSettingVC.swift
//  Kerdy
//
//  Created by 최다경 on 11/3/23.
//

import UIKit
import Core
import RxSwift

class SecondInitialSettingVC: UIViewController {
    
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
    
    private lazy var javaBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Java", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var SpringBootBtn: UIButton = {
        let button = UIButton()
        button.setTitle("SpringBoot", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var AWSBtn: UIButton = {
        let button = UIButton()
        button.setTitle("AWS", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var MySQLBtn: UIButton = {
        let button = UIButton()
        button.setTitle("MySQL", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var SQLBtn: UIButton = {
        let button = UIButton()
        button.setTitle("SQL", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var JavascriptBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Javascript", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var GithubBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Github", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var SpringBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Spring", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var PythonBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Python", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var DataAnalysisBtn: UIButton = {
        let button = UIButton()
        button.setTitle("데이터 분석", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var GitBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Git", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var DockerBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Docker", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var CommunicationBtn: UIButton = {
        let button = UIButton()
        button.setTitle("커뮤니케이션", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var TypescriptBtn: UIButton = {
        let button = UIButton()
        button.setTitle("typescript", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var ReactBtn: UIButton = {
        let button = UIButton()
        button.setTitle("React", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var categoryStackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var categoryStackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var categoryStackView3: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var categoryStackView4: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var categoryStackView5: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var categoryStackView6: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
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
            buttons.append(SpringBootBtn)
            buttons.append(AWSBtn)
            buttons.append(MySQLBtn)
            buttons.append(SQLBtn)
            buttons.append(JavascriptBtn)
            buttons.append(GithubBtn)
            buttons.append(SpringBtn)
            buttons.append(PythonBtn)
            buttons.append(DataAnalysisBtn)
            buttons.append(GitBtn)
            buttons.append(DockerBtn)
            buttons.append(CommunicationBtn)
            buttons.append(TypescriptBtn)
            buttons.append(ReactBtn)
        }
        setButton()
    }
    
    private func setLayout() {
        self.view.addSubview(progressLabel)
        self.view.addSubview(interestingPartLabel)
        self.view.addSubview(interestingCategoryLabel)
        self.view.addSubview(notifyLabel)
        self.view.addSubview(nextButton)
        self.view.addSubview(javaBtn)
        self.view.addSubview(SpringBootBtn)
        self.view.addSubview(AWSBtn)
        
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
        categoryStackView1.addArrangedSubview(SpringBootBtn)
        categoryStackView1.addArrangedSubview(AWSBtn)
        self.view.addSubview(categoryStackView1)
        
        javaBtn.snp.makeConstraints {
            $0.width.equalTo(77)
        }
        
        SpringBootBtn.snp.makeConstraints {
            $0.width.equalTo(117)
        }
        
        AWSBtn.snp.makeConstraints {
            $0.width.equalTo(79)
        }
    }
    
    private func setStackView2(){
        categoryStackView2.addArrangedSubview(MySQLBtn)
        categoryStackView2.addArrangedSubview(SQLBtn)
        categoryStackView2.addArrangedSubview(JavascriptBtn)
        self.view.addSubview(categoryStackView2)
        
        MySQLBtn.snp.makeConstraints {
            $0.width.equalTo(92)
        }
        
        SQLBtn.snp.makeConstraints {
            $0.width.equalTo(74)
        }
        
        JavascriptBtn.snp.makeConstraints {
            $0.width.equalTo(110)
        }
    }
    
    private func setStackView3(){
        categoryStackView3.addArrangedSubview(GithubBtn)
        categoryStackView3.addArrangedSubview(SpringBtn)
        categoryStackView3.addArrangedSubview(PythonBtn)
        self.view.addSubview(categoryStackView3)
        
        GithubBtn.snp.makeConstraints {
            $0.width.equalTo(90)
        }
        
        SpringBtn.snp.makeConstraints {
            $0.width.equalTo(89)
        }
        
        PythonBtn.snp.makeConstraints {
            $0.width.equalTo(92)
        }
    }
    
    private func setStackView4(){
        categoryStackView4.addArrangedSubview(DataAnalysisBtn)
        categoryStackView4.addArrangedSubview(GitBtn)
        categoryStackView4.addArrangedSubview(DockerBtn)
        self.view.addSubview(categoryStackView4)
        
        DataAnalysisBtn.snp.makeConstraints {
            $0.width.equalTo(113)
        }
        
        GitBtn.snp.makeConstraints {
            $0.width.equalTo(67)
        }
        
        DockerBtn.snp.makeConstraints {
            $0.width.equalTo(92)
        }
    }
    
    private func setStackView5(){
        categoryStackView5.addArrangedSubview(CommunicationBtn)
        categoryStackView5.addArrangedSubview(TypescriptBtn)
        self.view.addSubview(categoryStackView5)
        
        CommunicationBtn.snp.makeConstraints {
            $0.width.equalTo(121)
        }
        
        TypescriptBtn.snp.makeConstraints {
            $0.width.equalTo(110)
        }
    }
    
    private func setStackView6(){
        categoryStackView6.addArrangedSubview(ReactBtn)
        self.view.addSubview(categoryStackView6)
        
        ReactBtn.snp.makeConstraints {
            $0.width.equalTo(84)
        }
        
    }
    
    private func setButton(){
        for button in buttons {
            button.roundCorners(topLeft: 10, topRight: 20, bottomLeft: 20, bottomRight:10)
            let borderLayer = CAShapeLayer()
            borderLayer.path = (button.layer.mask! as! CAShapeLayer).path!
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
    
    private func setVerticalStackView(){
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
        
        self.view.addSubview(verticalStackView)
        
        verticalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(283)
            $0.leading.equalToSuperview().offset(21)
            $0.trailing.equalToSuperview().offset(-21)
        }
    }
    
    private func setUI() {
        self.view.backgroundColor = .systemBackground
    }
    
    @objc private func nextButtonTapped() {
        let nextViewController = ThirdInitialSettingVC()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc private func categoryButtonTapped(_ sender: UIButton){
        categoryViewModel.categoryButtonTapped(button: sender)
    }
}
