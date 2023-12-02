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

final class ThirdInitialSettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let educationViewModel = EducationViewModel()
    private let disposeBag = DisposeBag()
    private var buttons: [UIButton] = []
    private var isDataLoaded = false
    private var isDataLoading = false
    
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
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        return tv
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
        setTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        getEducationActivities()
    }
    
    private func getEducationActivities() {
        if !isDataLoaded && !isDataLoading {
            isDataLoading = true
            educationViewModel.educationActivities
                .subscribe(onNext: { clubActivities in
                    for activity in clubActivities {
                        let btn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(self.educationButtonTapped(_:)), title: activity.name)
                        btn.snp.makeConstraints { make in
                            make.width.equalTo((btn.titleLabel?.text!.count)! * 14)
                        }
                        self.buttons.append(btn)
                    }
                    self.tableView.reloadData()
                    if self.buttons.count >= 21 {
                        self.tableView.isScrollEnabled = true
                    } else {
                        self.tableView.isScrollEnabled = false
                    }
                    self.setButton()
                    self.isDataLoaded = true
                    self.isDataLoading = false
                }).disposed(by: disposeBag)

            educationViewModel.fetchActivities()
        }
    }
    
    private func setTableView() {
        view.addSubview(tableView)
        tableView.register(InitialSettingCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(277.5)
            $0.leading.equalToSuperview().offset(21)
            $0.trailing.equalToSuperview().offset(-21)
            $0.bottom.equalTo(enterLaterButton.snp.top).offset(-10)
        }
    }
    
    private func setLayout() {
        view.addSubviews(progressLabel, educationLabel, educationAskLabel, notifyLabel, nextButton, enterLaterButton, enterLaterButtonUnderline)
        
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
    
    private func setButton() {
        DispatchQueue.main.async {
            for button in self.buttons {
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
                
                self.educationViewModel.educationSelectedDict[button] = BehaviorSubject<Bool>(value: false)
                self.educationViewModel.educationSelectedDict[button]?.subscribe(onNext: {isSelected in
                    button.backgroundColor = isSelected ? .green : .white
                }).disposed(by: self.disposeBag)
                
                button.snp.makeConstraints {
                    $0.height.equalTo(32)
                }
            }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (buttons.count + 2) / 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InitialSettingCell
        cell.selectionStyle = .none

        if buttons.count > indexPath.row * 3 {
            cell.buttonStackView.addArrangedSubview(buttons[indexPath.row * 3])
        }
        if buttons.count > indexPath.row * 3 + 1 {
            cell.buttonStackView.addArrangedSubview(buttons[indexPath.row * 3 + 1])
        }
        if buttons.count > indexPath.row * 3 + 2 {
            cell.buttonStackView.addArrangedSubview(buttons[indexPath.row * 3 + 2])
        }
        return cell
    }
}
