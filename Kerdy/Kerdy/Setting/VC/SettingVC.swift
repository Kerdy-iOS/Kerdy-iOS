//
//  SettingVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 10/31/23.
//

import UIKit

final class SettingVC: BaseVC {
    
    // MARK: - Properties
    
    private lazy var settingDataSource = SettingDataSource(collectionView: collectionView)
    
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
        
        settingDataSource.delegate = self

        collectionView.dataSource = settingDataSource.dataSource
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
    }
}

// MAKR: - Methods

extension SettingVC: SettingProfileCellDelegate {
    
    func didSelectButton(type: WrittenSections) {
        let vc = SettingWrittenVC(type: type)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
