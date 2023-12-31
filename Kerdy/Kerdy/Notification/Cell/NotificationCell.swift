//
//  TagNotificationCell.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/22/23.
//

import UIKit

import SnapKit

import RxSwift
import RxCocoa
import RxDataSources

final class NotificationCell: UICollectionViewListCell {
    
    // MARK: - Property
    
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<TagSection>
    
    private var dataSource: DataSource!
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray01
        return view
    }()
    
    private let tagView: SwitchNotificationView = {
        let view = SwitchNotificationView()
        view.configureUI(title: Strings.notificationTag)
        view.setSwitchState(isOn: UserDefaultStore.isTagSelected)
        return view
    }()
    
    private let tagSubLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.subTag
        label.font = .nanumSquare(to: .regular, size: 11)
        label.textColor = .kerdyGray02
        return label
    }()
    
    fileprivate let addButton: UIButton = {
        let button = UIButton()
        button.setImage(.icAddButton, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.layout())
        view.allowsMultipleSelection = true
        view.bounces = false
        view.isScrollEnabled = false
        return view
    }()
    
    private let commentsView: SwitchNotificationView = {
        let view = SwitchNotificationView()
        view.configureUI(title: Strings.notificationComments)
        view.setSwitchState(isOn: UserDefaultStore.isCommentsSelected)
        return view
    }()
    
    private let noteView: SwitchNotificationView = {
        let view = SwitchNotificationView()
        view.configureUI(title: Strings.notificationNote)
        view.setSwitchState(isOn: UserDefaultStore.isNoteSelected)
        return view
    }()
    
    // MARK: - init
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setRegisteration()
        setLayout()
        setSwitchState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension NotificationCell {
    
    private func setRegisteration() {
        
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
    }
    
    private func setLayout() {
        
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        contentView.addSubview(tagView)
        tagView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(tagSubLabel)
        tagSubLabel.snp.makeConstraints {
            $0.top.equalTo(tagView.snp.bottom)
            $0.leading.equalToSuperview().inset(7)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(tagSubLabel.snp.bottom).offset(22)
            $0.height.equalTo(32)
        }
        
        contentView.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.top.equalTo(tagSubLabel.snp.bottom).offset(22)
            $0.leading.equalToSuperview().inset(7)
            $0.size.equalTo(CGSize(width: 60, height: 32))
        }
        
        contentView.addSubview(commentsView)
        commentsView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(10)
        }
        
        contentView.addSubview(noteView)
        noteView.snp.makeConstraints {
            $0.top.equalTo(commentsView.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        
        [tagView, collectionView, commentsView, noteView].forEach {
            $0.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(7)
                $0.trailing.equalToSuperview().inset(17)
            }
        }
    }
}

extension NotificationCell {
    
    private func configureDataSource() -> RxCollectionViewSectionedReloadDataSource<TagSection> {
        return RxCollectionViewSectionedReloadDataSource<TagSection>(
            configureCell: { _, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TagCell.identifier,
                    for: indexPath
                ) as? TagCell else { return UICollectionViewCell() }
                
                cell.configureCell(to: item, tagType: .userTag)
                return cell
            })
    }
}

extension NotificationCell {
    
    func setBindings(tagList: [TagsResponseDTO]) {
        collectionView.dataSource = nil
        collectionView.delegate = nil
        
        let dataSource = configureDataSource()
        
        resize(tagList: tagList)
        
        Observable.just(tagList)
            .map { [TagSection(items: $0)] }
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func selectedTagCell() -> Driver<TagsResponseDTO> {
        return collectionView.rx.modelSelected(TagsResponseDTO.self).asDriver()
    }
    
    private func resize(tagList: [TagsResponseDTO]) {
        
        let totalWidth: CGFloat = tagList
            .map { $0.name }
            .map({ $0.insetSize(xInset: 55).width })
            .reduce(65, +)
        let totalXInset: CGFloat = CGFloat(5 * (tagList.count - 1))
        let numberOfRows = ceil((totalWidth + totalXInset) / (contentView.bounds.width - 34))
        let height: CGFloat = numberOfRows * 32 + 11 * (numberOfRows - 1)
        
        self.collectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
    
    func setSwitchState() {
        
        tagView.rx.isSelected
            .bind { isSelected in
                UserDefaultStore.isTagSelected = isSelected
            }
            .disposed(by: disposeBag)
        
        commentsView.rx.isSelected
            .bind { isSelected in
                UserDefaultStore.isCommentsSelected = isSelected
            }
            .disposed(by: disposeBag)
        
        noteView.rx.isSelected
            .bind { isSelected in
                UserDefaultStore.isNoteSelected = isSelected
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - CollectionView Layout

extension NotificationCell {
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(30), heightDimension: .absolute(32))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(32))
        
        func createHorizontalGroup(insets: NSDirectionalEdgeInsets) -> NSCollectionLayoutGroup {
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(5)
            group.contentInsets = insets
            return group
        }
        
        let hgroup1 = createHorizontalGroup(insets: .init(top: 0, leading: 65, bottom: 0, trailing: 0))
        let hgroup2 = createHorizontalGroup(insets: .zero)
        
        let containerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let containerGroup = NSCollectionLayoutGroup.vertical(layoutSize: containerSize,
                                                              subitems: [hgroup1] + Array(repeating: hgroup2, count: 4))
        containerGroup.interItemSpacing = .fixed(11)
        
        let section = NSCollectionLayoutSection(group: containerGroup)
        section.orthogonalScrollingBehavior = .none
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Reactive extension

extension Reactive where Base: NotificationCell {
    
    var addButton: ControlEvent<Void> {
        base.addButton.rx.tap
    }
}
