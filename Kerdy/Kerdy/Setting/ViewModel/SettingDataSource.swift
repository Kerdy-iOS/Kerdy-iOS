//
//  SettingDataSource.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 10/31/23.
//

import UIKit

final class SettingDataSource {
    
    typealias CellRegistration = UICollectionView.CellRegistration
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int, CaseIterable {
        case profile
        case basic
    }
    
    enum Item: Hashable {
        case profile(ProfileResponseDTO)
        case basic(SettingBasicModel)
    }
    
    var dataSource: DataSource?
    var snapShot: SnapShot!
    
    var cellTappedHandler: ((IndexPath) -> Void)?
        
    private let collectionView: UICollectionView
    private let profileDate: [ProfileResponseDTO] = [ProfileResponseDTO.dummy()]
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
       
        let profileCellRegistration = CellRegistration<SettingProfileCell, ProfileResponseDTO> {cell, indexPath, item in
            cell.configureData(to: item)
            print("indxepath item  :\(indexPath.item), indexPath section : \(indexPath.section)")
//            self.cellTappedHandler?(indexPath)
        }
       
        let basicCellRegistration = CellRegistration<SettingBasicCell, SettingBasicModel> {cell, indexPath, item in
            cell.configureData(with: item, at: indexPath.item)
        }
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, _ in
            guard let sectionType = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            switch sectionType {
            case .profile:
                return collectionView.dequeueConfiguredReusableCell(using: profileCellRegistration,
                                                                    for: indexPath,
                                                                    item: .dummy())
            case .basic:
                let basicData = self.allBasicData[indexPath.item]
                return collectionView.dequeueConfiguredReusableCell(using: basicCellRegistration,
                                                                    for: indexPath,
                                                                    item: basicData)
            }
        })
    }
    
    private func setSnapShot() {
        
        snapShot = SnapShot()
        snapShot.appendSections(Section.allCases)
        snapShot.appendItems( profileDate.map { .profile($0) }, toSection: .profile)
        snapShot.appendItems( allBasicData.map { .basic($0) }, toSection: .basic)
        dataSource?.applySnapshotUsingReloadData(snapShot)
    }
    
    func updateSnapshot(profile: [ProfileResponseDTO]) {
        let currentProfile = snapShot.itemIdentifiers(inSection: .profile)
        let newProfile = currentProfile
        snapShot.deleteItems(currentProfile)
        snapShot.appendItems(newProfile, toSection: .profile)
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvirnment in
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
                let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvirnment)
                return section
                
            }
        }
    }
}
