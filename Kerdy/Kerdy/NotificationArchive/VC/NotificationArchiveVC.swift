//
//  NotificationArchiveVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 1/7/24.
//

import UIKit

import Core
import SnapKit

import RxSwift
import RxCocoa
import RxDataSources

final class NotificationArchiveVC: BaseVC {
    
    // MARK: - Property
    
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<ArchiveSectionModel>
    
    private var dataSource: DataSource!
    
    // MARK: - UI Components
    
    private let navigationBar: NavigationBarView = {
        let view = NavigationBarView()
        view.configureUI(to: Strings.archive)
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout())
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRegisteration()
        setLayout()
        setDelegate()
        setDataSource()
        
    }
}

// MARK: - Methods

extension NotificationArchiveVC {
    
    private func setRegisteration() {
        
        collectionView.register(ArchiveCell.self, forCellWithReuseIdentifier: ArchiveCell.identifier)
        collectionView.register(ArchiveHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ArchiveHeaderView.identifier)
    }
    
    private func setLayout() {
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeArea)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
    
    func setDataSource() {
        
        dataSource = DataSource(configureCell: { [weak self] _, tableView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            switch item {
            case .new, .old:
                guard let cell = tableView.dequeueReusableCell(
                    withReuseIdentifier: ArchiveCell.identifier,
                    for: indexPath
                ) as? ArchiveCell else { return UICollectionViewCell() }
                return cell
            }
        })
        
        dataSource.configureSupplementaryView = {(dataSource, collectionView, _, indexPath) -> UICollectionReusableView in
            
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: ArchiveHeaderView.identifier,
                for: indexPath
            ) as? ArchiveHeaderView else { return UICollectionReusableView() }
            
            header.configureHeader(title: dataSource[indexPath.section].title)
            return header
        }
    }
    
    private func setDelegate() {
        
        navigationBar.delegate = self
    }
}

// MARK: - Collectionview Layout

extension NotificationArchiveVC {
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
}

// MARK: - Navi BackButton Delegate

extension NotificationArchiveVC: BackButtonActionProtocol {
    
    func backButtonTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }
}
