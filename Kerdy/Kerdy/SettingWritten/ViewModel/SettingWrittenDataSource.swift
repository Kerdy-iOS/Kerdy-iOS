//
//  SettingWrittenDataSource.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/10/23.
//

import UIKit

import RxSwift

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
    let itemSelectedSubject = PublishSubject<Int>()

    private let disposeBag = DisposeBag()
    
    private var data: [Item] = []
    
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
                cell.configureUI(to: item)
            case .comment:
                cell.configureUI(to: item)
            }
        }
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistaion,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        })
        
        collectionView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] index in
                    guard let self = self else { return }
                    guard let commentID = self.data[index.item].commentID else { return }
                    self.itemSelectedSubject.onNext(commentID)
                })
            .disposed(by: disposeBag)
    }
    
    private func setSnapshot() {
        var snapShot = Snaphot()
        snapShot.appendSections([sectionType])
        snapShot.appendItems(data, toSection: sectionType)
        dataSource?.apply(snapShot)
    }
    
    func updateData(with items: [Item]) {
        data = items
        setSnapshot()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = true
        config.separatorConfiguration.bottomSeparatorInsets = .zero
        config.separatorConfiguration.color = .kerdyGray01
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
}
