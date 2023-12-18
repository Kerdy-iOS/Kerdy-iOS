//
//  CommentsSubView.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/18/23.
//

import UIKit

import Core
import SnapKit

import RxSwift
import RxCocoa

final class CommentsContainerView: UIView {
    
    // MARK: - Property
    
    // MARK: - UI Components
    
    private lazy var enterbutton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.titleAlignment = .center
        config.baseForegroundColor = .kerdyMain
        config.contentInsets = .init(top: 16, leading: 19, bottom: 16, trailing: 19)
        config.attributedTitle =  AttributedString(Strings.enterButton,
                                                   attributes: AttributeContainer([.font: UIFont.nanumSquare(to: .bold, size: 14)]))
        button.configuration = config
        return button
    }()
    
    private let comments: UITextField = {
        let textField = UITextField()
        textField.placeholder = Strings.placeholder
        textField.setPlaceholder(color: .kerdyGray02, font: .nanumSquare(to: .regular, size: 14))
        textField.makeBorder(width: 1, color: .kerdyGray02)
        textField.makeCornerRound(radius: 15)
        textField.setLeftPadding(amount: 19)
        textField.autocorrectionType = .no
        return textField
    }()
    
    // MARK: - Init
    
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

extension CommentsContainerView {
    
    private func setLayout() {
        
        self.snp.makeConstraints {
            $0.height.equalTo(74)
        }
        
        addSubview(comments)
        comments.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(18)
            $0.horizontalEdges.equalToSuperview().inset(17)
        }
    }
    
    private func setUI() {
        
        self.backgroundColor = .kerdyBackground
        comments.setRightView(enterbutton, width: 65)
    }
    
    func commentsText() -> Driver<String> {
        return comments.rx.text.orEmpty.asDriver()
    }
    
    func tapEnterButton() -> Signal<Void> {
        return enterbutton.rx.tap
            .do(onNext: { _ in self.comments.text = "" })
            .map { _ in () }
            .asSignal(onErrorJustReturn: ())
    }
}
