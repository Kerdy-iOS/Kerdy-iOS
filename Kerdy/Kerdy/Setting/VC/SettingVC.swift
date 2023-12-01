//
//  SettingVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 10/31/23.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

final class SettingVC: BaseVC {
    
    // MARK: - Properties
    
    private lazy var settingDataSource = SettingDataSource(collectionView: collectionView)
    
    private let viewModel: SettingViewModel
    private var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    // MARK: - Init
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MAKR: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Setting

extension SettingVC: DidSettingButtonTap {
    
    private func setLayout() {
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(safeArea)
        }
    }
    
    private func setUI() {
        
        collectionView.dataSource = settingDataSource.dataSource
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        
        settingDataSource.delegate = self
    }
    
    private func bind() {
        
        let input = SettingViewModel.Input(viewWillAppear: rx.viewWillAppear.asDriver())
        let output = viewModel.transform(input: input)
        
        output.settingList
            .asDriver()
            .drive(with: self) { owner, profileList in
                owner.settingDataSource.updateSnapshot(profile: [profileList])
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .filter { $0.section == 1 }
            .bind { indexpath in
                let viewControllers: [UIViewController.Type] = [NotificationVC.self,
                                                                BlockListVC.self,
                                                                TermsOfUseVC.self]
                
                guard indexpath.item < viewControllers.count else { return }
                let vc = viewControllers[indexpath.item].init()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func articleButtonDidTap() {
        
        let article = SettingWrittenVC(type: .article)
        self.navigationController?.pushViewController(article, animated: true)
    }
    
    func commentsButtonDidTap() {
        
        let comments = SettingWrittenVC(type: .comment)
        self.navigationController?.pushViewController(comments, animated: true)
    }
}
