//
//  MyBusinessCardVC.swift
//  Kerdy
//
//  Created by 최다경 on 12/10/23.
//

import UIKit
import SnapKit
import Core
import RxSwift
import RxCocoa
import Kingfisher

final class MyBusinessCardVC: UIViewController {
    
    let cellTitle = ["교육 활동", "동아리 활동"]
    
    private var memberInfo: MemberProfileResponseDTO?
    
    private let profileViewModel = ProfileViewModel.shared
    
    private let disposeBag = DisposeBag()
    
    private var activities: [Activity] = []
    
    private lazy var editBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.text = ""
        btn.setImage(.icEditProfile, for: .normal)
        btn.addTarget(self, action: #selector(editBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var helloLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello,"
        label.font = .nanumSquare(to: .bold, size: 34)
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.adjustsFontSizeToFitWidth = true
        label.font = .nanumSquare(to: .bold, size: 17)
        return label
    }()
    
    private lazy var introduceLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요 김개발입니다."
        label.font = .nanumSquare(to: .regular, size: 13)
        return label
    }()
    
    private lazy var userImgBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    private lazy var greenRing: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var categoryLabel1: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 10)
        label.textAlignment = .center
        label.backgroundColor = .kerdy_sub
        label.isHidden = true
        return label
    }()
    
    private lazy var categoryLabel2: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 10)
        label.textAlignment = .center
        label.backgroundColor = .kerdy_sub
        label.isHidden = true
        return label
    }()
    
    private lazy var categoryLabel3: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 10)
        label.textAlignment = .center
        label.backgroundColor = .kerdy_sub
        label.isHidden = true
        return label
    }()
    
    private lazy var categoryLabel4: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 10)
        label.textAlignment = .center
        label.backgroundColor = .kerdy_sub
        label.isHidden = true
        return label
    }()
    
    private lazy var divideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let categoryStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8.0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindViewModel()
        hideLabels()
    }
    
    override func viewWillLayoutSubviews() {
        bindViewModel()
        setUserImg()
        setGreenRing()
    }
    
    private func setActivities() {
        guard let activity = memberInfo?.activities else { return }
        activities = activity
    }
    
    private func bindViewModel() {
        
        profileViewModel.memberProfile
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] member in
                self?.memberInfo = member
                self?.setActivities()
                self?.nameLabel.text = member.name
                self?.userImgBtn.kf.setImage(with: URL(string: member.imageURL), for: .normal)
                self?.tableView.reloadData()
                if member.description.isEmpty {
                    self?.introduceLabel.text = "소개말이 없습니다."
                } else {
                    self?.introduceLabel.text = member.description
                }
            })
            .disposed(by: disposeBag)
        
        profileViewModel.myActivities
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
                self?.setMainCategory()
            })
            .disposed(by: disposeBag)
    }
    
    private func hideLabels() {
        let labels: [UILabel] = [categoryLabel1, categoryLabel2, categoryLabel3, categoryLabel4]
        for label in labels {
            label.isHidden = true
        }
    }
    
    private func setMainCategory() {
        let labels: [UILabel] = [categoryLabel1, categoryLabel2, categoryLabel3, categoryLabel4]
        
        DispatchQueue.main.async {
            let myJobActivities = self.profileViewModel.myActivities.value.filter { $0.activityType == "직무" }
            
            for i in 0..<myJobActivities.count {
                labels[i].isHidden = false
                labels[i].text = myJobActivities[i].name
                labels[i].snp.remakeConstraints {
                    $0.width.equalTo(labels[i].text!.count * 16)
                }
                labels[i].roundCorners(topLeft: 8, topRight: 16, bottomLeft: 16, bottomRight: 8)
                let borderLayer = CAShapeLayer()
                guard let buttonMaskLayer = labels[i].layer.mask as? CAShapeLayer else {
                    return
                }
                borderLayer.path = buttonMaskLayer.path
                borderLayer.strokeColor = UIColor.kerdySub.cgColor
                borderLayer.fillColor = UIColor.clear.cgColor
                borderLayer.lineWidth = 3
                borderLayer.frame = labels[i].bounds
                labels[i].layer.addSublayer(borderLayer)
            }
        }
    }
    
    private func setUserImg() {
        userImgBtn.layer.cornerRadius = userImgBtn.frame.height / 2
        userImgBtn.layer.borderWidth = 1
        userImgBtn.clipsToBounds = true
        userImgBtn.layer.borderColor = UIColor.clear.cgColor
        userImgBtn.addTarget(self, action: #selector(userImgBtnTapped), for: .touchUpInside)
    }
    
    private func setGreenRing() {
        greenRing.backgroundColor = .clear
        greenRing.layer.cornerRadius = userImgBtn.frame.height / 2 + 3
        greenRing.layer.borderWidth = 3
        greenRing.layer.borderColor = UIColor.kerdyMain.cgColor
        greenRing.clipsToBounds = true
    }
    
    private func setTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.register(ProfileActivityCell.self, forCellReuseIdentifier: "ProfileActivityCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    private func setLayout() {
        view.addSubviews(
            editBtn,
            helloLabel,
            nameLabel,
            introduceLabel,
            userImgBtn,
            greenRing,
            tableView,
            divideLine,
            scrollView
        )
        
        userImgBtn.superview?.bringSubviewToFront(userImgBtn)
        scrollView.addSubview(categoryStackView)
        
        categoryStackView.addArrangedSubviews(
            categoryLabel1,
            categoryLabel2,
            categoryLabel3,
            categoryLabel4
        )
        
        editBtn.snp.makeConstraints {
            $0.width.equalTo(22)
            $0.height.equalTo(22)
            $0.top.equalToSuperview().offset(47)
            $0.trailing.equalToSuperview().offset(-17)
        }
        
        helloLabel.snp.makeConstraints {
            $0.width.equalTo(90)
            $0.height.equalTo(30)
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().offset(17)
        }
        
        nameLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.top.equalToSuperview().offset(167)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalTo(greenRing.snp.leading).offset(-10)
        }
        
        introduceLabel.snp.makeConstraints {
            $0.width.equalTo(182)
            $0.height.equalTo(30)
            $0.top.equalToSuperview().offset(192)
            $0.leading.equalToSuperview().offset(17)
        }
        
        userImgBtn.snp.makeConstraints {
            $0.width.equalTo(125)
            $0.height.equalTo(115)
            $0.top.equalToSuperview().offset(110)
            $0.trailing.equalToSuperview().offset(-17)
        }
        
        greenRing.snp.makeConstraints {
            $0.top.equalToSuperview().offset(118)
            $0.trailing.equalToSuperview().offset(-10)
            $0.width.equalTo(userImgBtn.snp.width).offset(4)
            $0.height.equalTo(userImgBtn.snp.height).offset(4)
        }
        
        scrollView.snp.makeConstraints {
            $0.height.equalTo(26)
            $0.top.equalToSuperview().offset(251)
            $0.horizontalEdges.equalToSuperview().inset(17)
        }
        
        categoryStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        divideLine.snp.makeConstraints {
            $0.height.equalTo(0.3)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(categoryLabel1.snp.bottom).offset(10)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(introduceLabel.snp.bottom).offset(80)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc func userImgBtnTapped(_ sender: UIButton) {
        let imgVC = UserImageVC()
        imgVC.modalTransitionStyle = .coverVertical
        imgVC.modalPresentationStyle = .overCurrentContext
        self.present(imgVC, animated: false, completion: nil)
    }
    
    @objc func editBtnTapped(_ sender: UIButton) {
        let nextVC = ProfileEditVC()
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: false, completion: nil)
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
    }
    
}

extension MyBusinessCardVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileActivityCell", for: indexPath) as! ProfileActivityCell
        cell.selectionStyle = .none
        cell.titleLabel.text = cellTitle[indexPath.row]
        cell.addBtn.isHidden = true
        
        for btn in cell.activitySV.arrangedSubviews {
            cell.activitySV.removeArrangedSubview(btn)
            btn.removeFromSuperview()
        }
    
        let educationData = profileViewModel.myActivities.value.filter { $0.activityType == "교육" }

        let clubData = profileViewModel.myActivities.value.filter { $0.activityType == "동아리" }

        if indexPath.row == 0 {
            for data in educationData {
                let activitySV = ActivityBtn()
                activitySV.closeBtn.isHidden = true
                activitySV.closeBtn.isEnabled = false
                activitySV.setTitle(title: data.name)
                cell.activitySV.addArrangedSubview(activitySV)
                activitySV.snp.makeConstraints {
                    $0.height.equalTo(26)
                    $0.width.equalTo(200)
                }
            }
        } else {
            for data in clubData {
                let activitySV = ActivityBtn()
                activitySV.closeBtn.isHidden = true
                activitySV.closeBtn.isEnabled = false
                activitySV.setTitle(title: data.name)
                cell.activitySV.addArrangedSubview(activitySV)
                activitySV.snp.makeConstraints {
                    $0.height.equalTo(26)
                    $0.width.equalTo(200)
                }
            }
        }
                
        if indexPath.row == cellTitle.count - 1 {
            cell.divideLine.isHidden = true
        }
        
        return cell
    }
}
