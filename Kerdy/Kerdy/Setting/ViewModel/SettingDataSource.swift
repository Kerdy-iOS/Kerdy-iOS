//
//  SettingDataSource.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 10/31/23.
//

import UIKit

import RxSwift
import RxCocoa

final class SettingDataSource {
    
    typealias CellRegistration = UICollectionView.CellRegistration
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int, CaseIterable {
        case profile
        case basic
    }
    
    enum Item: Hashable {
        case profile(MemberProfileResponseDTO)
        case basic(SettingBasicModel)
    }
    
    var dataSource: DataSource?
    var snapShot: Snapshot!
    
    private var disposeBag = DisposeBag()
    weak var delegate: DidSettingButtonTap?
    
    private let collectionView: UICollectionView
    private var profileDate: [MemberProfileResponseDTO] = [.empty()]
    private let allBasicData: [SettingBasicModel] = SettingBasicModel.basicWithIcon + SettingBasicModel.basic
    
    init(dataSource: DataSource? = nil, collectionView: UICollectionView) {
        self.dataSource = dataSource
        self.collectionView = collectionView
        
        setCollectionView()
        setDataSource()
        setSnapShot()
    }
}

extension SettingDataSource {
    
    private func setCollectionView() {
        
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func setDataSource() {
        
        let profileCellRegistration = CellRegistration<SettingProfileCell, MemberProfileResponseDTO> {cell, _, item in
            cell.configureData(to: item)
            cell.setupButtonTapHandlers()
            cell.delegate = self.delegate
        }
        
        let basicCellRegistration = CellRegistration<SettingBasicCell, SettingBasicModel> {cell, indexPath, item in
            cell.configureData(with: item, at: indexPath.item)
        }
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            switch item {
            case .profile(let item):
                
                return collectionView.dequeueConfiguredReusableCell(using: profileCellRegistration,
                                                                    for: indexPath,
                                                                    item: item)
            case .basic(let item):
                return collectionView.dequeueConfiguredReusableCell(using: basicCellRegistration,
                                                                    for: indexPath,
                                                                    item: item)
            }
        })
    }
    
    private func setSnapShot() {
        
        snapShot = Snapshot()
        snapShot.appendSections(Section.allCases)
        snapShot.appendItems( profileDate.map { .profile($0) }, toSection: .profile)
        snapShot.appendItems( allBasicData.map { .basic($0) }, toSection: .basic)
        dataSource?.apply(snapShot, animatingDifferences: false)
        
    }
    
    func updateSnapshot(profile: [MemberProfileResponseDTO]) {
        
        profileDate = profile
        
        let currentProfile = snapShot.itemIdentifiers(inSection: .profile)
        let newProfile = profile.map { SettingDataSource.Item.profile($0) }
        
        guard var newSnapshot = snapShot else { return }
        newSnapshot.deleteItems(currentProfile)
        newSnapshot.appendItems(newProfile, toSection: .profile)
        
        DispatchQueue.main.async {
            self.dataSource?.apply(newSnapshot, animatingDifferences: false)
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard self != nil else { return nil }
            guard let sectionType = Section(rawValue: sectionIndex) else { return nil }
            switch sectionType {
            case .profile:
                let itemGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                           heightDimension: .absolute(195))
                let item = NSCollectionLayoutItem(layoutSize: itemGroupSize)
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: itemGroupSize,
                                                             subitem: item,
                                                             count: 1)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 0, bottom: 14, trailing: 0)
                
                return section
            case .basic:
                var config = UICollectionLayoutListConfiguration(appearance: .plain)
                config.showsSeparators = false
                let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
                return section
                
            }
        }
    }
}
