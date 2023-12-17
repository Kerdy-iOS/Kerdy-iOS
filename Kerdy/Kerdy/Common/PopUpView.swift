//
//  PopUpView.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/11/23.
//

import UIKit

import Core
import SnapKit

import RxSwift

protocol PopUptoBlockDelegate: AnyObject {
    func action(blockID: Int)
    func cancel()  
}

final class PopUpView: UIView {
    
    // MARK: - Property
    
    private var disposeBag = DisposeBag()
    weak var delegate: PopUptoBlockDelegate?
    
    private var blockID: Int = 0
    
    // MARK: - UI Components
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyBackground
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyBackground
        view.makeCornerRound(radius: 15)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 16)
        label.textColor = .kerdyBlack
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 14)
        label.textColor = .kerdyBlack
        return label
    }()
    
    private let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray01
        return view
    }()
    
    private let hStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 0
        return view
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.kerdyBlack, for: .normal)
        button.titleLabel?.font = .nanumSquare(to: .bold, size: 14)
        return button
    }()
    
    private let unlockButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.kerdyRed, for: .normal)
        button.titleLabel?.font = .nanumSquare(to: .bold, size: 14)
        return button
    }()
    
    private let separateLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray01
        return view
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

extension PopUpView {
    
    func setLayout() {
        
        self.addSubviews(dimmedView)
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(40)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(29)
            $0.centerX.equalToSuperview()
        }
        
        containerView.addSubview(subLabel)
        subLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(13)
            $0.centerX.equalToSuperview()
        }
        
        containerView.addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(24)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        containerView.addSubview(underLine)
        underLine.snp.makeConstraints {
            $0.top.equalTo(hStackView.snp.top)
            $0.height.equalTo(0.5)
            $0.horizontalEdges.equalToSuperview()
        }
        
        hStackView.addArrangedSubviews(cancelButton, separateLineView, unlockButton)
        separateLineView.snp.makeConstraints {
            $0.width.equalTo(0.5)
        }
        
        cancelButton.snp.makeConstraints {
            $0.width.equalTo(containerView.snp.width).dividedBy(2)
            $0.height.equalTo(55)
        }
    }
    
    func setUI() {
        
        dimmedView.backgroundColor = .kerdyBlack.withAlphaComponent(0.4)
        configureButton()
    }
    
    func configureTitle(title: String, subTitle: String, unlock: String) {
        
        titleLabel.text = title
        subLabel.text = subTitle
        unlockButton.setTitle(unlock, for: .normal)
    }
    
    func configureBlockID(id: Int) {
        
        self.blockID = id
    }
    
    func configureButton() {
        
        cancelButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.delegate?.cancel()
            }
            .disposed(by: disposeBag)
        
        unlockButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.delegate?.action(blockID: self.blockID)
            }
            .disposed(by: disposeBag)
    }
}
