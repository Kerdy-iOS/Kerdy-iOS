//
//  ChatDetailVC.swift
//  Kerdy
//
//  Created by 이동현 on 1/14/24.
//

import UIKit
import SnapKit

final class ChatDetailVC: UIViewController {
    private lazy var navigationBar = NavigationBarView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private lazy var textInputView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.kerdyGray01.cgColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    private var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "메시지를 입력하세요."
        textField.font = .nanumSquare(to: .regular, size: 14)
        return textField
    }()
    
    private var inputButton: UIButton = {
        let button = UIButton()
        button.setTitle("입력", for: .normal)
        button.titleLabel?.font = .nanumSquare(to: .bold, size: 14)
        button.setTitleColor(.kerdyMain, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    private func setUI() {
        navigationBar.delegate = self
    }
}

extension ChatDetailVC {
    private func setLayout() {
        view.addSubviews(
            navigationBar,
            collectionView,
            textInputView
        )
        
        textInputView.addSubviews(textField, inputButton)
        
        navigationBar.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(56)
        }
        
        textInputView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(17)
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.bottom.equalTo(textInputView.snp.top).inset(16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        inputButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(19)
            $0.width.equalTo(26)
        }
        
        textField.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(19)
            $0.trailing.equalTo(inputButton.snp.leading).inset(16)
        }
        
    }
}

// MARK: - 뒤로가기 delegate
extension ChatDetailVC: BackButtonActionProtocol {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
