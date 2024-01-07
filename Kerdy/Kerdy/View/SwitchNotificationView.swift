//
//  NotificationSwitchView.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/22/23.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

final class SwitchNotificationView: UIView {
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 15)
        return label
    }()
    
    fileprivate lazy var switchButton: UISwitch = {
        let button = UISwitch()
        button.onTintColor = .kerdyMain
        button.tintColor = .kerdyGray01
        button.thumbTintColor = .kerdyBackground
        button.setSize(width: 51, height: 31)
        return button
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setLayout()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension SwitchNotificationView {
    
    private func setLayout() {
        
        self.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
        }
        
        addSubview(switchButton)
        switchButton.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
        }
    }
    
    private func setUI() {
        
        backgroundColor = .clear
    }
    
    func configureUI(title: String) {
        
        titleLabel.text = title
    }
    
    func setSwitchState(isOn: Bool) {
        
        switchButton.isOn = isOn
    }
}

// MARK: - Reactive extension

extension Reactive where Base: SwitchNotificationView {
    
    var isSelected: ControlProperty<Bool> {
        base.switchButton.rx.isOn
    }
}
