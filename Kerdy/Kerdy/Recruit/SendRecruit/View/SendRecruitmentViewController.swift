//
//  SendRecruitmentViewController.swift
//  Kerdy
//
//  Created by 이동현 on 2/28/24.
//

import UIKit
import SnapKit
import Core

final class SendRecruitmentViewController: UIViewController {
    // MARK: - UI Property
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()
    
    private lazy var messageView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "쪽지 보내기"
        label.textAlignment = .center
        label.font = .nanumSquare(to: .bold, size: 15)
        return label
    }()
    private lazy var noticeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "xx님께 쪽지를 보내시겠습니까?"
        label.font = .nanumSquare(to: .bold, size: 13)
        return label
    }()
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.layer.borderColor = UIColor.kerdyGray01.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.textContainer.lineFragmentPadding = .zero
        view.textContainerInset = .init(
            top: 10,
            left: 10,
            bottom: 10,
            right: 10
        )
        view.font = .nanumSquare(to: .bold, size: 14)
        return view
    }()
    private lazy var placeholder: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 13)
        label.textColor = .kerdyGray01
        label.text = "입력해주세요."
        return label
    }()
    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .nanumSquare(to: .bold, size: 15)
        return button
    }()
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.kerdyMain, for: .normal)
        button.setTitle("보내기", for: .normal)
        button.titleLabel?.font = .nanumSquare(to: .bold, size: 15)
        return button
    }()
    private lazy var horizontalDivideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)
    private lazy var verticalDivideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI setting
extension SendRecruitmentViewController {
    private func setUI() {
        view.backgroundColor = .clear
        textView.delegate = self
        cancelButton.addTarget(self, action: #selector(cancelBtnTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendBtnTapped), for: .touchUpInside)
    }
}
// MARK: - layout 설정
extension SendRecruitmentViewController {
    private func setLayout() {
        view.addSubviews(
            backgroundView,
            messageView
        )
        
        messageView.addSubviews(
            titleLabel,
            noticeLabel,
            textView,
            placeholder,
            buttonStackView,
            horizontalDivideLine,
            verticalDivideLine
        )
        
        buttonStackView.addArrangedSubviews(cancelButton, sendButton)
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        messageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(50)
            $0.height.equalTo(100).priority(500)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(25)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.height.equalTo(150)
        }
        
        horizontalDivideLine.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(35)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(horizontalDivideLine.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        verticalDivideLine.snp.makeConstraints {
            $0.centerX.equalTo(buttonStackView)
            $0.height.equalTo(buttonStackView)
            $0.top.equalTo(buttonStackView)
            $0.width.equalTo(1)
        }
        
        placeholder.snp.makeConstraints {
            $0.top.equalTo(textView.snp.top).offset(10)
            $0.leading.equalTo(textView.snp.leading).offset(10)
        }
    }
}

// MARK: - method
extension SendRecruitmentViewController {
    @objc private func cancelBtnTapped() {
        dismiss(animated: false)
    }
    
    @objc private func sendBtnTapped() {
        // TODO: - 쪽지 전송 로직
    }
}

// MARK: - textView Delegate
extension SendRecruitmentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""

        placeholder.isHidden = !text.isEmpty
    }
}

// MARK: - touch
extension SendRecruitmentViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.endEditing(true)
    }
}
