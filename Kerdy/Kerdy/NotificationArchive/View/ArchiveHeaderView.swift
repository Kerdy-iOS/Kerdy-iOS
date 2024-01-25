//
//  ArchiveHeaderView.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 1/7/24.
//

import UIKit

import Core
import SnapKit

import RxSwift
import RxCocoa

final class ArchiveHeaderView: UICollectionReusableView {
    
    // MARK: - Property
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 14)
        return label
    }()
    
    fileprivate let allDelete: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.allDelete, for: .normal)
        button.setTitleColor(.kerdyGray02, for: .normal)
        button.titleLabel?.font = .nanumSquare(to: .bold, size: 12)
        return button
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray01
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension ArchiveHeaderView {
    
    private func setLayout() {
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(17)
        }
        
        self.addSubview(allDelete)
        allDelete.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(17)
        }
        
        self.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configureHeader(title: String, sectionIndex: Int) {
        
        titleLabel.text = title
        allDelete.isHidden = sectionIndex == 0
    }
}

// MARK: - Reactive extension

extension Reactive where Base: ArchiveHeaderView {

    var delete: ControlEvent<Void> {
        base.allDelete.rx.tap
    }
}
