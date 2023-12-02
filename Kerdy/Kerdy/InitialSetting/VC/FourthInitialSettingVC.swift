//
//  FourthInitialSettingVC.swift
//  Kerdy
//
//  Created by 최다경 on 11/4/23.
//

import UIKit
import Core
import RxSwift

final class FourthInitialSettingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let clubViewModel = ClubViewModel()
    private let disposeBag = DisposeBag()
    private var buttons: [UIButton] = []
    private var isDataLoaded = false
    private var isDataLoading = false
    
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
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        return tv
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
        setTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        getClubActivities()
    }
    
    private func getClubActivities() {
        if !isDataLoaded && !isDataLoading {
            isDataLoading = true
            clubViewModel.clubActivities
                .subscribe(onNext: { clubActivities in
                    for activity in clubActivities {
                        let btn: InitialSettingSelectBtn = InitialSettingSelectBtn(target: self, action: #selector(self.clubButtonTapped(_:)), title: activity.name)
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

            clubViewModel.fetchActivities()
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
        view.addSubviews(progressLabel, clubActivityLabel, askClubActivityLabel, notifyLabel, doneButton, enterLaterButton, enterLaterButtonUnderline)
        
        progressLabel.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(16)
            $0.top.equalToSuperview().offset(97)
            $0.leading.equalToSuperview().offset(21)
        }
        
        clubActivityLabel.snp.makeConstraints {
            $0.width.equalTo(68)
            $0.height.equalTo(16)
            $0.top.equalToSuperview().offset(121)
            $0.leading.equalToSuperview().offset(21)
        }
        
        askClubActivityLabel.snp.makeConstraints {
            $0.width.equalTo(185)
            $0.height.equalTo(23)
            $0.top.equalToSuperview().offset(174)
            $0.leading.equalToSuperview().offset(21)
        }
        
        notifyLabel.snp.makeConstraints {
            $0.width.equalTo(194)
            $0.height.equalTo(15)
            $0.top.equalToSuperview().offset(207)
            $0.leading.equalToSuperview().offset(21)
        }
        
        doneButton.snp.makeConstraints {
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
                
                self.clubViewModel.clubSelectedDict[button] = BehaviorSubject<Bool>(value: false)
                self.clubViewModel.clubSelectedDict[button]?.subscribe(onNext: {isSelected in
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
    
    private func setNaviBar() {
        navigationController?.navigationBar.tintColor = .kerdyGray01
        navigationItem.backButtonTitle = ""
    }
    
    @objc private func clubButtonTapped(_ sender: UIButton) {
        clubViewModel.clubButtonTapped(button: sender)
    }
    
    @objc private func enterLaterButtonTapped() {
        
    }
    
    @objc private func doneButtonTapped() {
        
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
