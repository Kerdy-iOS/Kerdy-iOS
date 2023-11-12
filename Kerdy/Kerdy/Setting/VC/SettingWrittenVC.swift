//
//  SettingWrittenVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/10/23.
//

import UIKit

final class SettingWrittenVC: BaseVC {
    
    // MARK: - Property
    
    private var type: WrittenSections
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private lazy var articleDataSource = SettingWrittenDataSource<ArticleResponseDTO>(collectionView: collectionView, type: .article)
    private lazy var commentDataSource = SettingWrittenDataSource<Comment>(collectionView: collectionView, type: .comment)
        
    // MARK: - UI Components
    
    private let navigationBar = NavigationBarView()
    
    // MARK: - Life Cycle
    
    init(type: WrittenSections) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setUI()
        setDataSource()
    }
}

// MARK: - Setting

extension SettingWrittenVC {
    
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
        navigationBar.configureUI(to: type.title)
        
    }
    
    private func setDataSource() {
        
        switch type {
        case .article:
            collectionView.dataSource = articleDataSource.dataSource
        case .comment:
            collectionView.dataSource = commentDataSource.dataSource
        }
    }
}
// MARK: - Method

// MARK: - Navi BackButton Delegate

extension SettingWrittenVC: BackButtonActionProtocol {
    
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
