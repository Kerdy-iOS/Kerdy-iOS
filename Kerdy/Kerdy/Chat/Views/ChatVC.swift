//
//  ChatVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 10/31/23.
//

import UIKit
import SnapKit
import Core

final class ChatVC: UITabBarController {
    
    private lazy var navigationView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "메시지"
        label.font = .nanumSquare(to: .bold, size: 14)
        return label
    }()
    
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setImage(.icMore, for: .normal)
        button.setTitle(nil, for: .normal)
        return button
    }()
    
    private lazy var divideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    private func setUI() {
        view.backgroundColor = .white
    }
}

// MARK: - layout 설정
extension ChatVC {
    private func setLayout() {
        view.addSubviews(navigationView, collectionView)
        navigationView.addSubviews(
            titleLabel,
            settingButton,
            divideLine
        )
        
        navigationView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(56)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        settingButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
            $0.size.equalTo(24)
        }
        
        divideLine.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(navigationView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
