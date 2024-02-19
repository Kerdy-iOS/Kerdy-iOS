//
//  ReportCompletedView.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 1/22/24.
//

import UIKit

import Core
import SnapKit

import RxSwift
import RxCocoa

protocol ReportDelegate: AnyObject {
    func action()
}

final class ReportCompletedView: UIView {
    
    // MARK: - Property
    
    var disposeBag = DisposeBag()
    weak var delegate: ReportDelegate?
        
    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 16)
        label.text = "신고 완료"
        label.textColor = .kerdyBlack
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 14)
        label.textColor = .kerdyBlack
        label.text = "커뮤니티 가이드에 따라 검토 후 처리 됩니다. 감사합니다."
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray01
        return view
    }()

    fileprivate let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.kerdyMain, for: .normal)
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = .nanumSquare(to: .bold, size: 14)
        return button
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

extension ReportCompletedView {
    
    func setLayout() {

        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(29)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(subLabel)
        subLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(13)
            $0.horizontalEdges.equalToSuperview().inset(46)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        self.addSubview(underLine)
        underLine.snp.makeConstraints {
            $0.top.equalTo(confirmButton.snp.top)
            $0.height.equalTo(0.5)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    func setUI() {
        
        self.backgroundColor = .kerdyBackground
        self.makeCornerRound(radius: 15)
    }
}

extension Reactive where Base: ReportCompletedView {
    var confirmButtonDidTap: ControlEvent<Void> {
        base.confirmButton.rx.tap
    }
}
