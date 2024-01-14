//
//  ProfileEditVC.swift
//  Kerdy
//
//  Created by 최다경 on 12/23/23.
//

import UIKit
import Core
import RxSwift
import RxCocoa

final class ProfileEditVC: UIViewController, ProfileActivityCellDelegate, ProfileTagBtnDelegate, ActivityBtnDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let cellTitle = ["교육 활동", "동아리 활동"]
    
    private var activities: [Activity] = []
    
    private let profileViewModel = ProfileViewModel.shared
    
    private let disposeBag = DisposeBag()
    
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
        btn.addTarget(self, action: #selector(doneBtnTapped), for: .touchUpInside)
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
        btn.addTarget(self, action: #selector(writeBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var descTextView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.textContainer.maximumNumberOfLines = 2
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.font = .nanumSquare(to: .regular, size: 13)
        textView.textColor = .kerdyGray04
        return textView
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
        btn.addTarget(self, action: #selector(cameraBtnTapped), for: .touchUpInside)
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
    
    private lazy var interestTag3: ProfileTagBtn = ProfileTagBtn()
    
    private lazy var interestTag4: ProfileTagBtn = ProfileTagBtn()
    
    private lazy var tableView: UITableView = UITableView()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setTableView()
        setTagCorners()
        setTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindViewModel()
    }
    
    override func viewWillLayoutSubviews() {
        setUserImg()
        setGreenRing()
    }

    private func setActivities() {
        guard let activity = profileViewModel.memberInfo.value?.activities else { return }
        activities = activity
    }
    
    private func bindViewModel() {
        profileViewModel.memberInfo
            .subscribe(onNext: { [weak self] member in
                guard let member = member else { return }
                self?.updateUI(member: member)
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        profileViewModel.myActivities
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        profileViewModel.myTags
            .subscribe(onNext: { [weak self] _ in
                self?.setTags()
            })
            .disposed(by: disposeBag)
    }

    private func updateUI(member: MemberProfileResponseDTO) {

        nameLabel.text = member.name
        userImgBtn.kf.setImage(with: URL(string: member.imageURL), for: .normal)
        
        if member.description.isEmpty {
            descTextView.text = "소개말이 없습니다."
        } else {
            descTextView.text = profileViewModel.memberInfo.value?.description
        }
    }
    
    private func setTextField() {
        descTextView.delegate = self
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
            descTextView,
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
            scrollView,
            tableView
        )
        
        scrollView.addSubview(categoryStackView)
        
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
        
        descTextView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(nameLabel.snp.bottom).offset(9)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-200)
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
            $0.top.equalTo(descTextView.snp.bottom).offset(5)
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
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(selectLabel.snp.bottom).offset(23)
            $0.height.equalTo(26)
            $0.horizontalEdges.equalToSuperview().inset(17)
        }
        
        categoryStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(addLabel.snp.bottom).offset(30)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    private func setTags() {
        let btns = [interestTag1, interestTag2, interestTag3, interestTag4]
        
        for btn in categoryStackView.arrangedSubviews {
            categoryStackView.removeArrangedSubview(btn)
            btn.removeFromSuperview()
        }
        
        for i in 0..<self.profileViewModel.myTags.value.count {
            btns[i].setTitle(title: self.profileViewModel.myTags.value[i].name)
            categoryStackView.addArrangedSubview(btns[i])
            btns[i].tagId = profileViewModel.myTags.value[i].id
            btns[i].delegate = self
        }
        setTagCorners()
    }
    
    private func setTagCorners() {
        DispatchQueue.main.async {
            for btn in self.categoryStackView.arrangedSubviews {
                btn.roundCorners(topLeft: 8, topRight: 16, bottomLeft: 16, bottomRight: 8)
            }
        }
    }
    
    private func openAlbum() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
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
    
    @objc func doneBtnTapped(_ sender: UIButton) {
        if let description = descTextView.text {
            self.profileViewModel.putMemberDescription(description: description)
                .subscribe(
                    onCompleted: { [weak self] in
                        self?.dismiss(animated: true, completion: nil)
                        
                    },
                    onError: { error in
                        print(error)
                    }
                )
                .disposed(by: disposeBag)
        }
    }
    
    func deleteBtnTapped(btn: ProfileTagBtn) {
        profileViewModel.deleteTag(id: btn.tagId!)
            .subscribe(onSuccess: { [weak self] isSuccess in
                if isSuccess {
                    btn.removeFromSuperview()
                    self?.categoryStackView.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileViewModel.updateProfileImage(image: image)
                .subscribe(
                    onCompleted: { [weak self] in
                        self?.userImgBtn.setImage(image, for: .normal)
                        self?.dismiss(animated: true, completion: nil)
                    }
                )
                .disposed(by: disposeBag)
        }
    }

    @objc func cameraBtnTapped(_ sender: UIButton) {
        openAlbum()
    }
    
    @objc func categoryAddBtnTapped(_ sender: UIButton) {
        let nextVC = CategoryEditHalfVC()
        let categoryCnt = ProfileViewModel.shared.myTags.value.count
        nextVC.selectLabel.text = "최대 \(4 - categoryCnt)개까지 선택 가능합니다."
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
    
    @objc func writeBtnTapped(_ sender: UIButton) {
        writeBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                if let description = self?.nameLabel.text {
                    self?.profileViewModel.putMemberDescription(description: description)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func addBtnTapped(cell: ProfileActivityCell) {
        if cell.titleLabel.text == "동아리 활동" {
            let nextVC = ProfileEditHalfVC()
            nextVC.isClub = true
            nextVC.interestingLabel.text = "상세 활동 선택"
            nextVC.selectLabel.text = "활동했던 이력들을 선택하고 추가하세요."
            if let sheet = nextVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
            self.present(nextVC, animated: true)
        } else {
            let nextVC = ProfileEditHalfVC()
            nextVC.isEdu = true
            nextVC.interestingLabel.text = "상세 활동 선택"
            nextVC.selectLabel.text = "활동했던 이력들을 선택하고 추가하세요."
            if let sheet = nextVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
            self.present(nextVC, animated: true)
        }
    }
    
    func deleteBtnTapped(btn: ActivityBtn) {
        profileViewModel.deleteActivityTag(id: btn.tagId)
            .subscribe(
                onCompleted: { [weak self] in
                    btn.removeFromSuperview()
                }
            )
            .disposed(by: disposeBag)
    }
}

extension ProfileEditVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileActivityCell", for: indexPath) as! ProfileActivityCell
        cell.selectionStyle = .none
        cell.titleLabel.text = cellTitle[indexPath.row]
        cell.delegate = self
        
        for btn in cell.activitySV.arrangedSubviews {
            cell.activitySV.removeArrangedSubview(btn)
            btn.removeFromSuperview()
        }
        
        let educationData = profileViewModel.myActivities.value.filter { $0.activityType == "교육" }

        let clubData = profileViewModel.myActivities.value.filter { $0.activityType == "동아리" }
        
        cell.activitySV.isUserInteractionEnabled = true
        
        if indexPath.row == 0 {
            for data in educationData {
                let activitySV = ActivityBtn()
                activitySV.setTitle(title: data.name)
                cell.activitySV.addArrangedSubview(activitySV)
                activitySV.closeBtn.isEnabled = true
                activitySV.tagId = data.id
                activitySV.delegate = self
                activitySV.snp.makeConstraints {
                    $0.height.equalTo(26)
                    $0.width.equalTo(200)
                }
            }
        } else {
            for data in clubData {
                let activitySV = ActivityBtn()
                activitySV.setTitle(title: data.name)
                activitySV.closeBtn.isEnabled = true
                activitySV.tagId = data.id
                cell.activitySV.addArrangedSubview(activitySV)
                activitySV.closeBtn.isEnabled = true
                activitySV.delegate = self
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

extension ProfileEditVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
           textView.resignFirstResponder()
           return false
       }
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 38
    }
}
