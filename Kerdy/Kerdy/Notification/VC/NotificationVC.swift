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
                                                willEnterForegroundNotification: NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification))
        let output = viewModel.transform(input: input)
        
        output.tagList
            .drive(with: self) { owner, data in
                let (tagList, isSwitch) = data
                owner.updateCollectionView(tagList: tagList, isSwitch: isSwitch)
            }
            .disposed(by: disposeBag)
        
        output.openNotificationSettings
            .drive(with: self) { _, _ in
                UIApplication.shared.openAppNotificationSettings()
            }
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
        
        let headerCellRegistration = UICollectionView.CellRegistration<HeaderNotificationCell, Bool> { cell, _, item in
            
            cell.configure(to: item)
            self.configureSwitch(cell: cell)
            self.configureBackgroundView(cell: cell)
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .header(let data):
                return collectionView.dequeueConfiguredReusableCell(using: headerCellRegistration,
                                                                    for: indexPath,
                                                                    item: data)
            case .cellItem(let data):
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                    for: indexPath,
                                                                    item: data)
            }
        }
    }
    
    private func updateCollectionView(tagList: [NotificationCellItem], isSwitch: Bool) {
        var sectionSnapshot = SectionSnapshot()
        
        let headerItem = NotificationItem.header(isSwitch)
        sectionSnapshot.append([headerItem])
        
        let cellItems = tagList.map { NotificationItem.cellItem($0) }
        
        sectionSnapshot.append(cellItems, to: headerItem)
        sectionSnapshot.expand([headerItem])
        
        dataSource.apply(sectionSnapshot, to: .main, animatingDifferences: false)
    }
    
    private func configureButton(cell: NotificationCell) {
        
        cell.rx.addButton
            .withUnretained(self)
            .bind { _ in
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
    
    private func configureSwitch(cell: HeaderNotificationCell) {
        
        cell.rx.valueChanged
            .skip(1)
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, isOn in
                owner.viewModel.handleSwitchValueChange(isOn)
            }
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
