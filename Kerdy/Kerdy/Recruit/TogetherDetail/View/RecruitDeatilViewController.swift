//
//  RecruitDeatilViewController.swift
//  Kerdy
//
//  Created by 이동현 on 2/28/24.
//

import UIKit
import SnapKit

final class RecruitDeatilViewController: UIViewController {
    // MARK: - UI Property
    private lazy var navigationBar = NavigationBarView()
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.setImage(.icMore, for: .normal)
        return button
    }()
    private lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.backgroundColor = .kerdyGray01
        return view
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = .nanumSquare(to: .bold, size: 13)
        return label
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "0000.00.22 수정됨"
        label.textColor = .kerdyGray02
        label.font = .nanumSquare(to: .regular, size: 11)
        return label
    }()
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "내용"
        label.font = .nanumSquare(to: .regular, size: 13)
        label.numberOfLines = 100
        return label
    }()
    private lazy var recruitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .kerdyMain
        button.tintColor = .white
        button.setTitle("함께하기 요청", for: .normal)
        button.titleLabel?.font = .nanumSquare(to: .bold, size: 16)
        button.layer.cornerRadius = 15
        return button
    }()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - setUI
extension RecruitDeatilViewController {
    private func setUI() {
        view.backgroundColor = .white
        navigationBar.configureUI(to: "함께해요")
        navigationBar.delegate = self
        menuButton.addTarget(self, action: #selector(menuBtnTapped), for: .touchUpInside)
        recruitButton.addTarget(self, action: #selector(recruitBtnTapped), for: .touchUpInside)
    }
}

// MARK: - layout 설정
extension RecruitDeatilViewController {
    private func setLayout() {
        view.addSubviews(
            navigationBar,
            menuButton,
            profileImageView,
            nameLabel,
            dateLabel,
            contentLabel,
            recruitButton
        )
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        menuButton.snp.makeConstraints {
            $0.centerY.equalTo(navigationBar)
            $0.trailing.equalTo(navigationBar.snp.trailing).offset(-8)
            $0.size.equalTo(24)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(17)
            $0.size.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(18)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(9)
            $0.height.equalTo(15)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(6)
            $0.leading.equalTo(nameLabel)
            $0.height.equalTo(12)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(17)
        }
        
        recruitButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(17)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-17)
            $0.height.equalTo(60)
        }
    }
}

// MARK: - method
extension RecruitDeatilViewController {
    @objc private func menuBtnTapped() {
        
        let deleteAlert = UIAlertController(title: "알림", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let okAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            //삭제 코드
        }
        deleteAlert.addAction(cancelAction)
        deleteAlert.addAction(okAction)
        
        let editAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "수정", style: .default) { [weak self] _ in
            let nextVC = CreateRecruitViewController()
            self?.navigationController?.pushViewController(nextVC, animated: true)
            
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.present(deleteAlert, animated: true)
        }
        editAlert.addAction(editAction)
        editAlert.addAction(deleteAction)
        
        let reportAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let reportAction = UIAlertAction(title: "신고", style: .destructive) { [weak self] _ in
            //신고 코드
        }
        reportAlert.addAction(reportAction)
        // TODO: - 사용자의 현재 상태에 따라 alert표시 구분
        let alert = true ? editAlert : reportAlert
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @objc private func recruitBtnTapped() {
        
    }
}

// MARK: - 뒤로가기 delegate
extension RecruitDeatilViewController: BackButtonActionProtocol {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
