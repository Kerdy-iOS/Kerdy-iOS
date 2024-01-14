//
//  ActivityEditHalfVC.swift
//  Kerdy
//
//  Created by 최다경 on 12/23/23.
//

import UIKit
import SnapKit

final class ActivityEditHalfVC: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "활동 종류"
        label.font = .nanumSquare(to: .bold, size: 16)
        return label
    }()
    
    private lazy var notesLabel: UILabel = {
        let label = UILabel()
        label.text = "활동이 어떤 종류에 속하는지 선택해주세요."
        label.font = .nanumSquare(to: .regular, size: 12)
        label.textColor = .kerdyGray04
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var baseView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var clubBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("     동아리 활동", for: .normal)
        btn.titleLabel?.font = .nanumSquare(to: .bold, size: 13)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderWidth = 2.0
        btn.layer.borderColor = UIColor.kerdyGray01.cgColor
        btn.layer.cornerRadius = 10.0
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(clubBtnTapped), for: .touchUpInside)
        return btn
    }()

    private lazy var educationBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("     교육 활동", for: .normal)
        btn.titleLabel?.font = .nanumSquare(to: .bold, size: 13)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderWidth = 2.0
        btn.layer.borderColor = UIColor.kerdyGray01.cgColor
        btn.layer.cornerRadius = 10.0
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(educationBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var grabBar: UIImageView = {
        let bar = UIImageView(image: .icGrabbar)
        return bar
    }()
    
    private lazy var nextBtn: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .nanumSquare(to: .regular, size: 16)
        button.backgroundColor = .kerdyMain
        button.layer.cornerRadius = 15
        button.setTitle("다음", for: .normal)
        button.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    private let maxDimmedAlpha: CGFloat = 0.6
    private let defaultHeight: CGFloat = 300
    private let dismissibleHeight: CGFloat = 200
    private let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    private var currentContainerHeight: CGFloat = 300
    
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setTabGesture()
        setupPanGesture()
    }
    
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    private func setUI() {
        view.backgroundColor = .clear
    }
    
    private func setTabGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    private func setLayout() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        containerView.addSubview(baseView)
    
        baseView.addSubviews(
            clubBtn,
            educationBtn,
            titleLabel,
            notesLabel,
            grabBar,
            nextBtn
        )
        
        grabBar.snp.makeConstraints {
            $0.width.equalTo(44)
            $0.height.equalTo(4)
            $0.top.equalToSuperview().offset(8)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(17)
        }
        
        notesLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(17)
        }
        
        clubBtn.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.equalToSuperview().offset(17)
            $0.top.equalTo(notesLabel.snp.bottom).offset(24)
            $0.trailing.equalTo(view.snp.centerX).offset(-3)
        }
        
        educationBtn.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.equalTo(view.snp.centerX).offset(3)
            $0.trailing.equalToSuperview().offset(-17)
            $0.top.equalTo(notesLabel.snp.bottom).offset(24)
        }
        
        nextBtn.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-17)
            $0.bottom.equalToSuperview().offset(-25)
        }
        
        baseView.snp.makeConstraints { make in
            make.top.equalTo(containerView)
            make.bottom.equalTo(containerView)
            make.leading.equalTo(containerView)
            make.trailing.equalTo(containerView)
        }
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true

    }
    @objc func clubBtnTapped(_ sender: UIButton) {
        clubBtn.isSelected = true
        clubBtn.layer.borderColor = UIColor.kerdyMain.cgColor
        educationBtn.isSelected = false
        educationBtn.layer.borderColor = UIColor.kerdyGray01.cgColor
    }

    @objc func educationBtnTapped(_ sender: UIButton) {
        clubBtn.isSelected = false
        clubBtn.layer.borderColor = UIColor.kerdyGray01.cgColor
        educationBtn.isSelected = true
        educationBtn.layer.borderColor = UIColor.kerdyMain.cgColor
    }

    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        let newHeight = currentContainerHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < maximumContainerHeight {
                containerViewHeightConstraint?.constant = newHeight
                view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            } else if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
            } else if newHeight < maximumContainerHeight && isDraggingDown {
                animateContainerHeight(defaultHeight)
            } else if newHeight > defaultHeight && !isDraggingDown {
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
    
    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }
    
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    private func animateDismissView() {
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func nextBtnTapped(_ sender: UIButton) {
        let nextVC = ProfileEditHalfVC()
        nextVC.interestingLabel.text = "상세 활동 선택"
        nextVC.selectLabel.text = "활동했던 이력들을 선택하고 추가하세요."
        
        if clubBtn.isSelected {
            nextVC.isClub = true
        } else {
            nextVC.isEdu = true
        }
        
        if let sheet = nextVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        guard let pvc = self.presentingViewController else { return }

        self.dismiss(animated: false) {
          pvc.present(nextVC, animated: true, completion: nil)
        }
    }
}
