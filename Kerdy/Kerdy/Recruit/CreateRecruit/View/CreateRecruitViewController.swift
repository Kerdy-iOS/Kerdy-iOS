//
//  CreateRecruitViewController.swift
//  Kerdy
//
//  Created by 이동현 on 2/28/24.
//

import UIKit
import Core
import SnapKit

final class CreateRecruitViewController: UIViewController {
    // MARK: - UI Property
    private lazy var navigationBar = NavigationBarView()
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록", for: .normal)
        button.setTitleColor(.kerdyMain, for: .normal)
        button.titleLabel?.font = .nanumSquare(to: .bold, size: 14)
        return button
    }()
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.textContainer.lineFragmentPadding = .zero
        view.textContainerInset = .init(
            top: 16,
            left: 17,
            bottom: 16,
            right: 17
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
    private lazy var divideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }

    // MARK: - set UI
    private func setUI() {
        view.backgroundColor = .white
        navigationBar.configureUI(to: "글쓰기")
        textView.delegate = self
    }
}

// MARK: - layout 설정
extension CreateRecruitViewController {
    private func setLayout() {
        view.addSubviews(
            navigationBar,
            registerButton,
            divideLine,
            textView,
            placeholder
        )
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        registerButton.snp.makeConstraints {
            $0.centerY.equalTo(navigationBar)
            $0.trailing.equalTo(navigationBar.snp.trailing).offset(-17)
            $0.width.equalTo(26)
            $0.height.equalTo(18)
        }
        
        divideLine.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(divideLine.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        placeholder.snp.makeConstraints {
            $0.top.equalTo(divideLine.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(17)
        }
    }
}

// MARK: - textView delegate
extension CreateRecruitViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        
        placeholder.isHidden = !text.isEmpty
    }
}

// MARK: - touch
extension CreateRecruitViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.endEditing(true)
    }
}
