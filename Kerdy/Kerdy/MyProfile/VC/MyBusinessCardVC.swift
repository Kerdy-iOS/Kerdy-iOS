//
//  MyBusinessCardVC.swift
//  Kerdy
//
//  Created by 최다경 on 12/10/23.
//

import UIKit
import SnapKit
import Core

class MyBusinessCardVC: UIViewController {
    
    let clubDummy = ["DDD5 기5", "KEEPER 12기6"]
    let educationDummy = ["DDD 5기", "KEEPER 12기", "멋쟁이 사자들 5기"]
    let dummyTitle = ["교육 활동", "동아리 활동"]
    
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
        label.text = "김커디"
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
        btn.setImage(.imgUser, for: .normal)
        return btn
    }()
    
    private lazy var greenRing: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var categoryLabel1: UILabel = {
        let label = UILabel()
        label.text = "iOS"
        label.font = .nanumSquare(to: .regular, size: 10)
        label.textAlignment = .center
        label.backgroundColor = .kerdy_sub
        return label
    }()
    
    private lazy var categoryLabel2: UILabel = {
        let label = UILabel()
        label.text = "안드로이드"
        label.font = .nanumSquare(to: .regular, size: 10)
        label.textAlignment = .center
        label.backgroundColor = .kerdy_sub
        return label
    }()
    
    private lazy var divideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setTableView()
    }
    
    override func viewWillLayoutSubviews() {
        setUserImg()
        setGreenRing()
        setMainCategory()
    }
    
    private func setMainCategory() {
        categoryLabel1.roundCorners(topLeft: 8, topRight: 16, bottomLeft: 16, bottomRight: 8)
        let borderLayer = CAShapeLayer()
        guard let buttonMaskLayer = categoryLabel1.layer.mask as? CAShapeLayer else {
            return
        }
        borderLayer.path = buttonMaskLayer.path
        borderLayer.strokeColor = UIColor(named: "kerdy_sub")?.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 3
        borderLayer.frame = categoryLabel1.bounds
        categoryLabel1.layer.addSublayer(borderLayer)
        
        categoryLabel2.roundCorners(topLeft: 8, topRight: 16, bottomLeft: 16, bottomRight: 8)
        let borderLayer2 = CAShapeLayer()
        guard let buttonMaskLayer = categoryLabel2.layer.mask as? CAShapeLayer else {
            return
        }
        borderLayer2.path = buttonMaskLayer.path
        borderLayer2.strokeColor = UIColor(named: "kerdy_sub")?.cgColor
        borderLayer2.fillColor = UIColor.clear.cgColor
        borderLayer2.lineWidth = 3
        borderLayer2.frame = categoryLabel2.bounds
        categoryLabel2.layer.addSublayer(borderLayer2)
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
        tableView.register(ProfileActivityCell.self, forCellReuseIdentifier: "ProfileActivityCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    private func setLayout() {
        view.addSubviews(editBtn, helloLabel, nameLabel, introduceLabel, userImgBtn, greenRing, tableView, categoryLabel1, categoryLabel2, divideLine)
        userImgBtn.superview?.bringSubviewToFront(userImgBtn)
        
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
            $0.width.equalTo(47)
            $0.height.equalTo(16)
            $0.top.equalToSuperview().offset(167)
            $0.leading.equalToSuperview().offset(17)
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
        
        categoryLabel1.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(26)
            $0.top.equalToSuperview().offset(251)
            $0.leading.equalToSuperview().offset(17)
        }
        
        categoryLabel2.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(26)
            $0.top.equalToSuperview().offset(251)
            $0.leading.equalTo(categoryLabel1.snp.trailingMargin).offset(15)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileActivityCell", for: indexPath) as! ProfileActivityCell
        cell.selectionStyle = .none
        cell.titleLabel.text = dummyTitle[indexPath.row]
        cell.addBtn.isHidden = true
        
        let clearView: UIView = {
            let view = UIView()
            view.backgroundColor = .clear
            return view
        }()
        
        if indexPath.row == 0 {
            for data in educationDummy {
                let activitySV = ProfileTagBtn()
                activitySV.img.isHidden = true
                activitySV.closeBtn.isEnabled = false
                activitySV.setTitle(title: data)
                cell.labels.append(activitySV)
            }
        } else {
            for data in clubDummy {
                let activitySV = ProfileTagBtn()
                activitySV.img.isHidden = true
                activitySV.closeBtn.isEnabled = false
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
