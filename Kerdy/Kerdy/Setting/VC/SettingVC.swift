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
    
    private let viewmodel = SettingViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    // MAKR: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setUI()
        bind()
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
    
    private func bind() {
        
        let input = SettingViewModel.Input(viewWillAppear: rx.viewWillAppear.asObservable())
        let output = viewmodel.transform(input: input)
        
        output.settingList.asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, profileList in
                owner.settingDataSource.updateSnapshot(profile: profileList)
            }
            .disposed(by: disposeBag)
    
        collectionView.rx.itemSelected
            .bind { indexpath in
                var vc: UIViewController
                switch indexpath.item {
                case 0: vc = NotificationVC()
                case 1: vc = BlockListVC()
                case 2: vc = TermsOfUseVC()
                default:
                   return
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MAKR: - Methods

extension SettingVC: SettingProfileCellDelegate {
    
    func didSelectButton(type: WrittenSections) {
        let vc = SettingWrittenVC(type: type)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
