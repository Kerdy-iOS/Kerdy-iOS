//
//  SettingWrittenDataSource.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/10/23.
//

import UIKit

enum WrittenSections: Int {
    
    case article
    case comment
}

final class SettingWrittenDataSource<T: SettingWrittenProtocol> {
    
    // MARK: - Property
    
    typealias Item = T
    typealias CellRegistration = UICollectionView.CellRegistration
    typealias DataSource = UICollectionViewDiffableDataSource<WrittenSections, Item>
    typealias Snaphot = NSDiffableDataSourceSnapshot<WrittenSections, Item>
    
    var dataSource: DataSource?
    var sectionType: WrittenSections
    
    private var data: [Item] = []
    private var count: [Int] = []
    
    // MARK: - UI Components
    
    private let collectionView: UICollectionView
    
    // MARK: - Initialize
    
    init(collectionView: UICollectionView, type: WrittenSections) {
        self.collectionView = collectionView
        self.sectionType = type
        
        setCollectionView()
        setDataSource()
        setSnapshot()
    }
}

extension SettingWrittenDataSource {
    
    private func setCollectionView() {
        
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func setDataSource() {
        
        let cellRegistaion = CellRegistration<SettingWriteCell, Item> { cell, indexPath, item in
            
            switch self.sectionType {
            case .article:
                cell.configureUI(type: self.sectionType, to: item)
            case .comment:
                let count = self.count[indexPath.item]
                cell.configureUI(type: self.sectionType,
                                 to: item,
                                 count: count)
                
            }
        }
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistaion,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        })
        
    }
    
    private func setSnapshot() {
        var snapShot = Snaphot()
        snapShot.appendSections([sectionType])
        snapShot.appendItems(data, toSection: sectionType)
        dataSource?.apply(snapShot)
    }
    
    func updateData(with items: [Item], count: [Int]? = nil) {
        data = items
        
        if let count = count {
            self.count = count
        }
        setSnapshot()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = true
        config.separatorConfiguration.bottomSeparatorInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
}
