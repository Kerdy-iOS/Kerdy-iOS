//
//  SettingVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 10/31/23.
//

import UIKit
import RxSwift

final class SettingVC: BaseVC {
    
    // MARK: - Properties
    
    private lazy var settingDataSource = SettingDataSource(collectionView: collectionView)
    
    private let viewModel =  SettingViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    // MARK: - Init
    
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
        
        collectionView.dataSource = settingDataSource.dataSource
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
    }
    
    private func bind() {
        
        let input = SettingViewModel.Input(viewWillAppear: rx.viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.settingList.asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, profileList in
                owner.settingDataSource.updateSnapshot(profile: profileList)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .filter { $0.section == 1 }
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
        
        collectionView.rx.itemSelected
            .filter { $0.section == 0 }
            .flatMap { [weak self] indexPath -> Observable<SettingProfileCell> in
                dump(indexPath)
                guard let cell = self?.collectionView.cellForItem(at: indexPath) as? SettingProfileCell else { return .empty() }
                return .just(cell)
            }
            .debug()
            .bind(with: self) { owner, cell in
                owner.bind(cell: cell)
            }
            .disposed(by: disposeBag)

                
    }
    
    private func bind(cell: SettingProfileCell) {
        
        let input = SettingViewModel.CellInput(tapProfileButton: cell.editProfileButtonDidTap(),
                                               tapArticleButton: cell.articleButtonDidTap(),
                                               tapCommentsButton: cell.commentsButtonDidTap())
        let output = viewModel.transform(input: input)
        
        output.didProfileButtonTapped
            .emit()
            .disposed(by: disposeBag)
        
        output.didArticleButtonTapped
            .emit { _ in
                let article = SettingWrittenVC(type: .article)
                self.navigationController?.pushViewController(article, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.didCommentsButtonTapped
            .emit { _ in
                let comments = SettingWrittenVC(type: .comment)
                self.navigationController?.pushViewController(comments, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
}
