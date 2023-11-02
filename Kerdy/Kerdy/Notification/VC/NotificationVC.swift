//
//  NotificationVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/1/23.
//

import UIKit

import Core

final class NotificationVC: UIViewController {
    
    // MARK: - Property
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    // MARK: - UI Property
    
    private let modalTopView: ModalTopView = {
        let view = ModalTopView()
        view.configureUI(to: Strings.notificationTitle)
        return view
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray01
        return view
    }()
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.notification
        label.font = .nanumSquare(to: .regular, size: 14)
        label.textColor = .kerdyBlack
        return label
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.notificationTag
        label.font = .nanumSquare(to: .bold, size: 15)
        label.textColor = .kerdyBlack
        label.setLineSpacing(lineSpacing: 1.15)
        return label
    }()
    
    private let tagSubLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.subTag
        label.font = .nanumSquare(to: .regular, size: 11)
        label.textColor = .kerdyGray02
        return label
    }()
    
    private lazy var switchButton: UISwitch = {
        let button = UISwitch()
        button.onTintColor = .kerdyMain
        button.tintColor = .kerdyGray01
        button.thumbTintColor = .kerdyBackground
        button.setSize(width: 36, height: 20)
        return button
    }()
 
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        setUI()
    }

}

// MARK: = Methods

extension NotificationVC {
    
    private func setLayout() {
        
        view.addSubview(modalTopView)
        modalTopView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeArea)
        }
        
        view.addSubview(notificationLabel)
        notificationLabel.snp.makeConstraints {
            $0.top.equalTo(modalTopView.snp.bottom).offset(23)
            $0.leading.equalTo(safeArea).inset(17)
        }
        
        view.addSubview(switchButton)
        switchButton.snp.makeConstraints {
            $0.centerY.equalTo(notificationLabel.snp.centerY)
            $0.trailing.equalTo(safeArea).inset(17)
        }
        
        view.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.top.equalTo(notificationLabel.snp.bottom).offset(23)
            $0.horizontalEdges.equalTo(safeArea)
            $0.height.equalTo(0.5)
        }
        
        view.addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(25)
            $0.leading.equalTo(safeArea).inset(17)
        }
        
        view.addSubview(tagSubLabel)
        tagSubLabel.snp.makeConstraints {
            $0.top.equalTo(tagLabel.snp.bottom).offset(14)
            $0.leading.equalTo(safeArea).inset(17)
        }
    }
    
    private func setUI() {
        
        view.backgroundColor = .kerdyBackground
        modalTopView.delegate = self
        
    }
}

// MARK: - Protocol

extension NotificationVC: ButtonActionProtocol {
    
    func cancelButtonTapped() {
        print("Tapped")
    }
}
