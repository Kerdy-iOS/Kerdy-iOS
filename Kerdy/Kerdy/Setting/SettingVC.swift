//
//  SettingVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 10/31/23.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Core

final class SettingVC: UIViewController {
    
    // MARK: - Properties
    
    private lazy var settingDataSource = SettingDataSource(collectionView: collectionView)
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    // MARK: - UI Components
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    // MAKR: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setUI()
        
    }
    
}

// MARK: - Setting

extension SettingVC {
    
    private func setLayout() {
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(safeArea)
        }
    }
    
    private func setUI() {
        
        view.backgroundColor = .kerdyMain
        
        collectionView.dataSource = settingDataSource.dataSource
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
    }
}

// MAKR: - Methods

extension SettingVC {
    
}
