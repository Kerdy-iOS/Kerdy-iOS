//
//  SecondInitialSettingVC.swift
//  Kerdy
//
//  Created by 최다경 on 11/3/23.
//

import UIKit
import Core
import RxSwift
import Moya

final class SecondInitialSettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let categoryViewModel = CategoryViewModel()
    private let disposeBag = DisposeBag()
    private var buttons: [UIButton] = []
    private var isDataLoaded = false
    private var isDataLoading = false
    
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
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setUI()
        setLayout()
        setNaviBar()
        setTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        getJobActivities()
    }
    
    private func getJobActivities() {
        if !isDataLoaded && !isDataLoading {
            isDataLoading = true
            categoryViewModel.jobActivities
                .subscribe(onNext: { clubActivities in
                    for activity in clubActivities {
                        let btn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(self.categoryButtonTapped(_:)), title: activity.name)
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

            categoryViewModel.fetchActivities()
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
            $0.bottom.equalTo(nextButton.snp.top).offset(-10)
        }
    }
    
    private func setLayout() {
        view.addSubviews(progressLabel, interestingPartLabel, interestingCategoryLabel, notifyLabel, nextButton)
        
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
                
                self.categoryViewModel.categorySelectedDict[button] = BehaviorSubject<Bool>(value: false)
                self.categoryViewModel.categorySelectedDict[button]?.subscribe(onNext: {isSelected in
                    button.backgroundColor = isSelected ? .green : .white
                }).disposed(by: self.disposeBag)
                
                button.snp.makeConstraints {
                    $0.height.equalTo(32)
                }
            }
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
