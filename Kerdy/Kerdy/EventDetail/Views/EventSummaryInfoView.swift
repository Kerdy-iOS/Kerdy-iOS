//
//  EventSummaryInfoView.swift
//  Kerdy
//
//  Created by 이동현 on 11/24/23.
//

import UIKit
import SnapKit

final class EventSummaryInfoView: UIView {
    // MARK: - Typealias
    typealias TagCell = EventDetailTagCell
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Tag>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Tag>
    
    // MARK: - UI Property
    private lazy var dDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .kerdyMain
        label.font = .nanumSquare(to: .extraBold, size: 13)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 15)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var organizerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .kerdyGray03
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()
    
    private lazy var tagCollectionView: UICollectionView = {
        let layout = createCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    // MARK: - Property
    private var dataSource: DataSource?
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    func configure(date: String, title: String, organization: String, tags: [Tag]) {
        dDayLabel.text = DateManager.shared.getDdayString(date)
        titleLabel.text = title
        organizerLabel.text = organization
        configureDataSource(tags: tags)
    }
}

// MARK: - Layout 설정
extension EventSummaryInfoView {
    private func setLayout() {
        addSubviews(
            dDayLabel,
            titleLabel,
            organizerLabel,
            tagCollectionView
        )
        
        dDayLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(17)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dDayLabel.snp.bottom).offset(9)
            $0.leading.equalTo(dDayLabel.snp.leading)
        }
        
        organizerLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.equalTo(dDayLabel.snp.leading)
        }
        
        tagCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(17)
            $0.top.equalTo(organizerLabel.snp.bottom).offset(23)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(22)
        }
    }
}

// MARK: - CollectionView 설정
extension EventSummaryInfoView {
    private func configureDataSource(tags: [Tag]) {
        let cellRegistration = UICollectionView.CellRegistration<TagCell, Tag> { cell, _, item in
            cell.configure(tag: item.name)
        }
        
        dataSource = DataSource(collectionView: tagCollectionView) { (
            collectionView: UICollectionView,
            indexPath: IndexPath,
            identifier: Tag
        ) -> UICollectionViewCell? in return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: identifier
            )
        }
        
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(tags, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
        
        let itemCount = tagCollectionView.numberOfItems(inSection: 0)
        tagCollectionView.snp.updateConstraints {
            $0.height.equalTo(22 + 25 * (itemCount / 5))
        }
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(50),
            heightDimension: .absolute(22)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(0),
            top: .fixed(0),
            trailing: .fixed(3),
            bottom: .fixed(0)
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(22)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 3
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
