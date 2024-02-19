//
//  CommonNotificationCell.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/24/23.
//

import UIKit

import RxSwift
import RxCocoa

final class HeaderNotificationCell: UICollectionViewListCell {
    
    // MARK: - Property
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    lazy var switchView: UISwitch = {
        let view = UISwitch()
        view.onTintColor = .kerdyMain
        
        return view
    }()
    
    // MARK: - init
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension HeaderNotificationCell {
    
    private func setUI() {
        
        var content = defaultContentConfiguration()
        content.text = Strings.receiveAllNotification
        content.textProperties.font = .nanumSquare(to: .regular, size: 14)
        contentConfiguration = content
        accessories = [
            .customView(configuration: .init(customView: switchView, placement: .trailing()))
        ]
    }
    
    func configure(to data: Bool) {
        switchView.isOn = data
    }
}

// MARK: - Reactive extension

extension Reactive where Base: HeaderNotificationCell {
    
    var valueChanged: ControlProperty<Bool> {
        base.switchView.rx.isOn
    }
}
