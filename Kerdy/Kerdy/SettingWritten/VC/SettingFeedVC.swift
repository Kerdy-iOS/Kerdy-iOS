//
//  SettingFeedVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/11/23.
//

import UIKit

import RxSwift
import RxCocoa

final class SettingFeedVC: BaseVC {
    
    // MARK: - Property
    
    private let viewModel: SettingFeedViewModel
    private var disposdBag = DisposeBag()
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private lazy var articleDataSource = SettingWrittenDataSource<FeedResponseDTO>(collectionView: collectionView, type: .article)
    
    // MARK: - UI Components
    
    private let navigationBar: NavigationBarView = {
        let view = NavigationBarView()
        view.configureUI(to: "작성한 글")
        return view
    }()
    
    // MARK: - Life Cycle
    
    init(viewModel: SettingFeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setUI()
        setBindings()
    }
}

// MARK: - Setting

extension SettingFeedVC {
    
    private func setLayout() {
        
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(safeArea)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setUI() {
        
        navigationBar.delegate = self
        collectionView.dataSource = articleDataSource.dataSource
    }
    
    private func setBindings() {
        
        let input = SettingFeedViewModel.Input(viewWillAppear: rx.viewWillAppear.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.feedList
            .drive(with: self) { owner, feedList in
                owner.articleDataSource.updateData(with: feedList)
            }
            .disposed(by: disposdBag)
    }
}

// MARK: - Navi BackButton Delegate

extension SettingFeedVC: BackButtonActionProtocol {
    
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
