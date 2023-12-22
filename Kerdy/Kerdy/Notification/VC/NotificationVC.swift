//
//  NotificationVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/1/23.
//

import UIKit

import Core
import SnapKit

import RxSwift
import RxCocoa

final class NotificationVC: BaseVC {
    
    // MARK: - Property
    
    typealias DataSource = UICollectionViewDiffableDataSource<NotificationSection, NotificationItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<NotificationSection, NotificationItem>
    typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<NotificationItem>
    typealias Item = NotificationCellItem
    
    private var dataSource: DataSource!
    private let viewModel: NotificationViewModel
    
    // MARK: - UI Property
    
    private let navigationBar: NavigationBarView = {
        let view = NavigationBarView()
        view.configureUI(to: Strings.notificationTitle)
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.layout())
        return view
    }()
    
    private let switchView: UISwitch = {
        let view = UISwitch()
        view.onTintColor = .kerdyMain
        return view
    }()
    
    // MARK: - Init
    
    init(viewModel: NotificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setDelegate()
        setDataSource()
        setBindings()
    }
}

// MARK: = Methods

extension NotificationVC {
    
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
        
        let input = NotificationViewModel.Input(viewWillAppear: rx.viewWillAppear.asDriver(),
                                                switchValueChanged: switchView.rx.isOn.asDriver())
        let output = viewModel.transform(input: input)
        
        output.isSwitch
            .drive(with: self, onNext: { owner, data in
                let (isSwitch, tagList) = data
                owner.updateCollectionView(isSwitch: isSwitch, tagList: tagList)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - DataSource

extension NotificationVC {
    
    func setDataSource() {
        
        let cellRegistration =  UICollectionView.CellRegistration<NotificationCell, Item> { cell, _, item  in
            
            cell.setBindings(tagList: item.tagList)
            self.configureButton(cell: cell)
            self.configureBackgroundView(cell: cell)
        }
        
        let headerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, UUID> { cell, _, _ in
            
            var content = cell.defaultContentConfiguration()
            content.text = Strings.receiveAllNotification
            content.textProperties.font = .nanumSquare(to: .regular, size: 14)
            cell.contentConfiguration = content
            
            cell.accessories = [
                .customView(configuration: .init(customView: self.switchView,
                                                 placement: .trailing()))
            ]
            self.configureBackgroundView(cell: cell)
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .header(let uuid):
                return collectionView.dequeueConfiguredReusableCell(using: headerCellRegistration,
                                                                    for: indexPath,
                                                                    item: uuid)
            case .cellItem(let data):
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                    for: indexPath,
                                                                    item: data)
            }
        }
    }
    
    private func updateCollectionView(isSwitch: Bool, tagList: [NotificationCellItem]) {
        var sectionSnapshot = SectionSnapshot()
        
        let headerItem = NotificationItem.header(UUID())
        sectionSnapshot.append([headerItem])
        
        let cellItems = isSwitch ? tagList.map { NotificationItem.cellItem($0) } : []
        sectionSnapshot.append(cellItems, to: headerItem)
        isSwitch ? sectionSnapshot.expand([headerItem]) : sectionSnapshot.collapse([headerItem])
        
        dataSource.apply(sectionSnapshot, to: .main, animatingDifferences: false)
    }
    
    private func configureButton(cell: NotificationCell) {
        
        cell.rx.addButton
            .withUnretained(self)
            .bind {_ in
                let vc = TagVC(viewModel: TagViewModel(tagManager: TagManager.shared))
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: cell.disposeBag)
        
        cell.selectedTagCell()
            .drive(with: self, onNext: { owner, selectedTag in
                owner.viewModel.deleteTags(id: [selectedTag.id])
            })
            .disposed(by: cell.disposeBag)
    }
}

// MARK: - CollectionView Layout

extension NotificationVC {
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
    
    private func configureBackgroundView(cell: UICollectionViewListCell) {
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = selectedBackgroundView
    }
}

// MARK: - Navi BackButton Delegate

extension NotificationVC: BackButtonActionProtocol {
    
    func backButtonTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }
}
