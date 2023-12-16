//
//  BlockListVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import UIKit

import Core
import SnapKit

final class BlockListVC: UIViewController {
    
    // MAKR: - Property
    
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, BlockListModel>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, BlockListModel>
    
    private var dataSource: DataSource?
    private var dummyData: [BlockListModel] = BlockListModel.dummy()
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    // MAKR: - UI Property
    
    private let navigationBar: NavigationBarView = {
        let view = NavigationBarView()
        view.configureUI(to: Strings.blockTitle)
        return view
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.blockSubTitle
        label.font = .nanumSquare(to: .regular, size: 11)
        label.textColor = .kerdyGray02
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        return view
        
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setUI()
        setDataSource()
        setSnapShot()
        
    }
}

// MARK: - Methods

private extension BlockListVC {
    
    func setLayout() {
        
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeArea)
        }
        
        view.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(8)
            $0.centerX.equalTo(safeArea)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalTo(safeArea)
            $0.bottom.equalToSuperview()
        }
        
    }
    
    func setUI() {
        view.backgroundColor = .kerdyBackground
        navigationBar.delegate = self
    }
}

// MARK: - Navi BackButton Delegate

extension BlockListVC: BackButtonActionProtocol {
    
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension BlockListVC {
    
    private func setDataSource() {
        
        let cellRegisteration = UICollectionView.CellRegistration<BlockListCell, BlockListModel> { cell, _, item in
            cell.configureCell(to: item)
        }
        
        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegisteration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
    }
    
    private func setSnapShot() {
        
        var snapshot = SnapShot()
        defer { self.dataSource?.applySnapshotUsingReloadData(snapshot)}
        
        snapshot.appendSections([.main])
        snapshot.appendItems(dummyData)
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
}
