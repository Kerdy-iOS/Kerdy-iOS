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
    private let viewModel: ArchiveViewModel
    
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
    
    // MARK: - Init
    
    init(viewModel: ArchiveViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MAKR: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRegisteration()
        setLayout()
        setDelegate()
        setDataSource()
        setBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func setDelegate() {
        
        navigationBar.delegate = self
    }
    
    private func setBindings() {
        let input = ArchiveViewModel.Input(viewWillAppear: rx.viewWillAppear.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.archiveList
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .bind(with: self) { owner, index in
                owner.viewModel.updateList(index: index) {
                    owner.viewModel.patchNotification(id: $0)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func setDataSource() {
        
        dataSource = DataSource(configureCell: { [weak self] _, tableView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            switch item {
            case .new(let data), .old(let data):
                guard let cell = tableView.dequeueReusableCell(
                    withReuseIdentifier: ArchiveCell.identifier,
                    for: indexPath
                ) as? ArchiveCell else { return UICollectionViewCell() }
                cell.configure(data: data)
                self.configure(cell: cell, index: indexPath)
                return cell
            }
        }, configureSupplementaryView: { dataSource, collectionView, _, indexPath in
            
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: ArchiveHeaderView.identifier,
                for: indexPath
            ) as? ArchiveHeaderView else { return UICollectionReusableView() }
            
            let title = dataSource[indexPath.section].title
            header.configureHeader(title: title, sectionIndex: indexPath.section)
            self.configure(header: header, index: indexPath)
            return header
        })
    }
}

extension NotificationArchiveVC {
    
    func configure(cell: ArchiveCell, index: IndexPath) {
        
        cell.rx.delete
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.viewModel.updateList(index: index) {
                    owner.viewModel.deleteNotification(ids: [$0])
                }
            }
            .disposed(by: cell.disposeBag)
    }
    
    func configure(header: ArchiveHeaderView, index: IndexPath) {
        header.rx.delete
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.viewModel.deleteAllNotification(index: index)
            }
            .disposed(by: header.disposeBag)
    }
}

// MARK: - Collectionview Layout

extension NotificationArchiveVC {
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        var config = UICollectionLayoutListConfiguration(appearance: .grouped)
        config.showsSeparators = false
        config.headerMode = .supplementary
        config.backgroundColor = .clear
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
