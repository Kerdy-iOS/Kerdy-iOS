//
//  ProfileEditVC.swift
//  Kerdy
//
//  Created by 최다경 on 12/23/23.
//

import UIKit
import Core

class ProfileEditVC: UIViewController, ProfileActivityCellDelegate {
    
    let clubDummy = ["DDD5 기5", "KEEPER 12기6"]
    let educationDummy = ["DDD 5기", "KEEPER 12기", "멋쟁이 사자들 5기"]
    let dummyTitle = ["교육 활동", "동아리 활동"]
    
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.icCancel, for: .normal)
        btn.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 수정"
        label.font = .nanumSquare(to: .bold, size: 14)
        return label
    }()
    
    private lazy var doneBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("완료", for: .normal)
        btn.setTitleColor(.kerdyMain, for: .normal)
        btn.titleLabel?.font = .nanumSquare(to: .regular, size: 14)
        return btn
    }()
    
    private lazy var nameLabel: UILabel = {
       let label = UILabel()
        label.text = "김커디"
        label.font = .nanumSquare(to: .bold, size: 17)
        return label
    }()
    
    private lazy var introduceLabel: UILabel = {
        let label = UILabel()
        label.text = "소개말을 입력하세요."
        label.textColor = .kerdyGray04
        label.font = .nanumSquare(to: .regular, size: 13)
        return label
    }()
    
    private lazy var writeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.icPencil, for: .normal)
        return btn
    }()
    
    private lazy var userImgBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "img_user"), for: .normal)
        btn.setImage(.imgUser, for: .normal)
        btn.addTarget(self, action: #selector(userImgBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var greenRing: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var cameraBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.icCamera, for: .normal)
        return btn
    }()
    
    private lazy var upperDivideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)
    
    private lazy var lowerDivideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)
    
    private lazy var interestingLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 가테고리"
        label.font = .nanumSquare(to: .bold, size: 14)
        return label
    }()
    
    private lazy var selectLabel: UILabel = {
        let label = UILabel()
        label.text = "내가 관심있는 분야를 선택하세요."
        label.font = .nanumSquare(to: .regular, size: 11)
        label.textColor = .kerdyGray04
        return label
    }()
    
    private lazy var categoryAddBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.icAddButtonFilled, for: .normal)
        btn.addTarget(self, action: #selector(categoryAddBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var activityAddBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.icAddButtonFilled, for: .normal)
        btn.addTarget(self, action: #selector(activityAddBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var activityLabel: UILabel = {
        let label = UILabel()
        label.text = "활동"
        label.font = .nanumSquare(to: .bold, size: 14)
        return label
    }()
    
    private lazy var addLabel: UILabel = {
        let label = UILabel()
        label.text = "활동했던 이력을 추가해보세요."
        label.font = .nanumSquare(to: .regular, size: 11)
        label.textColor = .kerdyGray04
        return label
    }()
    
    private lazy var categoryStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .equalSpacing
        sv.spacing = 5
        return sv
    }()
    
    private lazy var interestTag1: ProfileTagBtn = ProfileTagBtn()
    
    private lazy var interestTag2: ProfileTagBtn = ProfileTagBtn()
    
    private lazy var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setTags()
        setTableView()
    }
    
    override func viewWillLayoutSubviews() {
        setUserImg()
        setGreenRing()
        interestTag1.setCorner()
        interestTag2.setCorner()
    }
    
    private func setTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ProfileActivityCell.self, forCellReuseIdentifier: "ProfileActivityCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    private func setLayout() {
        
        view.addSubviews(
            closeBtn,
            titleLabel,
            doneBtn,
            nameLabel,
            introduceLabel,
            writeBtn,
            greenRing,
            userImgBtn,
            cameraBtn,
            upperDivideLine,
            interestingLabel,
            selectLabel,
            categoryAddBtn,
            lowerDivideLine,
            activityLabel,
            addLabel,
            activityAddBtn,
            categoryStackView,
            tableView
        )
        
        categoryStackView.addArrangedSubviews(interestTag1, interestTag2)
        
        closeBtn.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(24)
            $0.top.equalToSuperview().offset(55)
            $0.leading.equalToSuperview().offset(17)
        }
        
        titleLabel.snp.makeConstraints {
            $0.width.equalTo(68)
            $0.height.equalTo(18)
            $0.top.equalToSuperview().offset(59)
            $0.centerX.equalToSuperview()
        }
        
        doneBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(54)
            $0.trailing.equalToSuperview().offset(-17)
        }
        
        nameLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.top.equalToSuperview().offset(184)
            $0.leading.equalToSuperview().offset(17)
        }
        
        introduceLabel.snp.makeConstraints {
            $0.height.equalTo(15)
            $0.top.equalTo(nameLabel.snp.bottom).offset(9)
            $0.leading.equalToSuperview().offset(17)
        }
        
        writeBtn.snp.makeConstraints {
            $0.width.equalTo(13)
            $0.height.equalTo(13)
            $0.top.equalTo(nameLabel.snp.bottom).offset(9)
            $0.leading.equalTo(introduceLabel.snp.trailing).offset(5)
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
        
        cameraBtn.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.height.equalTo(70)
            $0.top.equalToSuperview().offset(183)
            $0.trailing.equalToSuperview().offset(-5)
        }
        
        upperDivideLine.snp.makeConstraints {
            $0.height.equalTo(0.3)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(introduceLabel.snp.bottom).offset(30)
        }
        
        interestingLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.leading.equalToSuperview().offset(17)
            $0.top.equalTo(upperDivideLine.snp.bottom).offset(24)
        }
        
        selectLabel.snp.makeConstraints {
            $0.height.equalTo(12)
            $0.leading.equalToSuperview().offset(17)
            $0.top.equalTo(interestingLabel.snp.bottom).offset(8)
        }
        
        categoryAddBtn.snp.makeConstraints {
            $0.width.equalTo(59)
            $0.height.equalTo(32)
            $0.top.equalTo(upperDivideLine.snp.bottom).offset(26)
            $0.trailing.equalToSuperview().offset(-17)
        }
        
        lowerDivideLine.snp.makeConstraints {
            $0.height.equalTo(0.3)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(upperDivideLine.snp.bottom).offset(133)
        }
        
        activityLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.top.equalTo(lowerDivideLine.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(17)
        }
        
        addLabel.snp.makeConstraints {
            $0.height.equalTo(12)
            $0.top.equalTo(activityLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(17)
        }
        
        activityAddBtn.snp.makeConstraints {
            $0.width.equalTo(59)
            $0.height.equalTo(32)
            $0.top.equalTo(lowerDivideLine.snp.bottom).offset(26)
            $0.trailing.equalToSuperview().offset(-17)
        }
        
        categoryStackView.snp.makeConstraints {
            $0.top.equalTo(selectLabel.snp.bottom).offset(23)
            $0.leading.equalToSuperview().offset(17)
        }
        
        interestTag1.snp.makeConstraints {
            $0.top.equalTo(selectLabel.snp.bottom).offset(23)
            $0.height.equalTo(26)
        }
        
        interestTag2.snp.makeConstraints {
            $0.top.equalTo(selectLabel.snp.bottom).offset(23)
            $0.height.equalTo(26)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(addLabel.snp.bottom).offset(30)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    private func setTags() {
        interestTag1.setTitle(title: "iOS")
        interestTag2.setTitle(title: "안드로이드")
    }
    
    private func setUserImg() {
        userImgBtn.layer.cornerRadius = userImgBtn.frame.height / 2
        userImgBtn.layer.borderWidth = 1
        userImgBtn.clipsToBounds = true
        userImgBtn.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func setGreenRing() {
        greenRing.backgroundColor = .clear
        greenRing.layer.cornerRadius = userImgBtn.frame.height / 2 + 3
        greenRing.layer.borderWidth = 3
        greenRing.layer.borderColor = UIColor.kerdyMain.cgColor
        greenRing.clipsToBounds = true
    }

    private func setUI() {
        view.backgroundColor = .white
    }
    
    @objc func closeBtnTapped(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @objc func cameraBtnTapped(_ sender: UIButton) {
        
    }
    
    @objc func categoryAddBtnTapped(_ sender: UIButton) {
        let nextVC = ProfileEditHalfVC()
        if let sheet = nextVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        self.present(nextVC, animated: true)
    }
    
    @objc func activityAddBtnTapped(_ sender: UIButton) {
        let vc = ActivityEditHalfVC()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    @objc func userImgBtnTapped(_ sender: UIButton) {
        let imgVC = UserImageVC()
        imgVC.modalTransitionStyle = .coverVertical
        imgVC.modalPresentationStyle = .overCurrentContext
        self.present(imgVC, animated: false, completion: nil)
    }
    
    func addBtnTapped(cell: ProfileActivityCell) {
        if cell.titleLabel.text == "동아리 활동" {
            let nextVC = ProfileEditHalfVC()
            if let sheet = nextVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
            self.present(nextVC, animated: true)
        } else {
            let nextVC = ProfileEditHalfVC()
            if let sheet = nextVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
            self.present(nextVC, animated: true)
        }
    }
}

extension ProfileEditVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileActivityCell", for: indexPath) as! ProfileActivityCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.titleLabel.text = dummyTitle[indexPath.row]
        
        let clearView: UIView = {
            let view = UIView()
            view.backgroundColor = .clear
            return view
        }()
        
        if indexPath.row == 0 {
            for data in educationDummy {
                let activitySV = ProfileTagBtn()
                activitySV.setTitle(title: data)
                cell.labels.append(activitySV)
            }
        } else {
            for data in clubDummy {
                let activitySV = ProfileTagBtn()
                activitySV.setTitle(title: data)
                cell.labels.append(activitySV)
            }
        }

        for label in cell.labels {
            let dotImg: UIImageView = {
                let img = UIImageView()
                img.image = .icDot
                return img
            }()
            cell.contentView.addSubview(label)
            cell.contentView.addSubview(dotImg)
            
            dotImg.snp.makeConstraints {
                $0.top.equalToSuperview().offset(cell.labelOffset + 5)
                $0.leading.equalToSuperview().offset(46)
            }
            
            label.snp.makeConstraints {
                $0.top.equalToSuperview().offset(cell.labelOffset - 5)
                $0.height.equalTo(26)
                $0.leading.equalToSuperview().offset(45)
            }
            cell.labelOffset += 25
        }
        
        cell.contentView.addSubview(clearView)
        
        clearView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(cell.labelOffset)
            $0.leading.equalToSuperview().offset(46)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        if indexPath.row == 1 {
            cell.divideLine.isHidden = true
        }
        
        return cell
    }
}
