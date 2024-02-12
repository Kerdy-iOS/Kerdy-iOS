//
//  HomeViewController.swift
//  Kerdy
//
//  Created by 이동현 on 2023/10/28.
//

import UIKit
import SnapKit
import Core
import RxSwift
import RxCocoa

protocol EventScrapDelegate: AnyObject {
    func scrapStateChanged()
}

final class EventVC: BaseVC {
    // MARK: - TypeAlias
    typealias EventCell = EventCollectionViewCell
    typealias FilterCell = FilterCollectionViewCell
    typealias DataSource = UICollectionViewDiffableDataSource<Int, FilterItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, FilterItem>
    
    // MARK: - UI Property
    private lazy var searchContainerView = UIView()

    private lazy var searchView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.kerdyGray01.cgColor
        return view
    }()

    private lazy var searchImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .kerdyGray01
        return imageView
    }()

    private lazy var searchTF: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        return textField
    }()

    private lazy var notificationBtn: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.setImage(UIImage(named: "ic_alert"), for: .normal)
        return button
    }()

    private lazy var categoryContainerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.addArrangedSubview(CategoryView(title: "스크랩", tag: 0))
        view.addArrangedSubview(CategoryView(title: "컨퍼런스", tag: 1))
        view.addArrangedSubview(CategoryView(title: "대회", tag: 2))

        for subview in view.arrangedSubviews {
            if let categoryView = subview as? CategoryView {
                categoryView.button.addTarget(self, action: #selector(categoryBtnTapped), for: .touchUpInside)
            }
        }

        return view
    }()

    private lazy var itemCountContainerView = ItemCountView()

    private lazy var filterBtn: FilterSettingBtn = {
        let view = FilterSettingBtn()
        view.button.addTarget(self, action: #selector(filterBtnTapped), for: .touchUpInside)
        return view
    }()

    private lazy var filterContainerView = UIView()
    
    private lazy var filterCollectionView: UICollectionView = {
        let layout = createCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var eventCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()

    private lazy var divideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)
    
    // MARK: - Property
    private var dataSource: DataSource?
    private let viewModel = EventViewModel()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setUI()
    }
    
    // MARK: - UI Setting
    private func setUI() {
        view.backgroundColor = .systemBackground
        filterCollectionView.delegate = self
        configureDataSource()
        setupCollectionViewBindings()
    }
    
    // MARK: - Method
    private func updateCategory(index: Int) {
        for categoryIndex in 0...2 {
            guard
                let categoryView = categoryContainerView.arrangedSubviews[categoryIndex] as? CategoryView
            else { return }

            if categoryIndex == index {
                categoryView.setSelected()
            } else {
                categoryView.setUnselected()
            }
        }
        
        viewModel.setEventCVIndex(index: index)
    }

    @objc func categoryBtnTapped(_ sender: UIButton) {
        let tag = sender.tag
        let indexPath = IndexPath(item: tag, section: 0)
        eventCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateCategory(index: tag)
    }

    @objc func filterBtnTapped(_ sender: UIButton) {
        let nextVC = FilterVC()
        nextVC.delegate = self
        nextVC.setViewModel(filter: viewModel.getCurrentFilter())
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - 레이아웃 설정
extension EventVC {
    private func setLayout() {
        view.addSubviews(
            searchContainerView,
            categoryContainerView,
            filterContainerView,
            divideLine
        )

        setUpSearchContainerViewLayout()
        setUpCategoryContainerViewLayout()
        setUpfilterContainerViewLayout()
        setEventCollectionViewLayout()

        searchContainerView.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
        }

        filterContainerView.snp.makeConstraints {
            $0.height.equalTo(46).priority(250)
            $0.top.equalTo(categoryContainerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }

        divideLine.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(filterContainerView.snp.bottom)
        }
    }

    private func setUpsearchViewLayout() {
        searchView.addSubview(searchImage)
        searchView.addSubview(searchTF)

        searchImage.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(24)
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }

        searchTF.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(searchImage.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
        }
    }

    private func setUpSearchContainerViewLayout() {
        setUpsearchViewLayout()
        searchContainerView.addSubview(searchView)
        searchContainerView.addSubview(notificationBtn)

        searchView.snp.makeConstraints {
            $0.width.equalTo(242)
            $0.height.equalTo(36)
            $0.leading.equalToSuperview().offset(17)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }

        notificationBtn.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(24)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalToSuperview().offset(-14)
        }
    }

    private func setUpCategoryContainerViewLayout() {
        categoryContainerView.snp.makeConstraints {
            $0.height.equalTo(38)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(searchContainerView.snp.bottom)
        }
    }

    private func setUpfilterContainerViewLayout() {
        filterContainerView.addSubviews(
            itemCountContainerView,
            filterBtn,
            filterCollectionView
        )

        itemCountContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(17)
            $0.width.equalTo(50)
            $0.height.equalTo(14)
        }

        filterBtn.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(14)
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-17)
        }
        
        filterCollectionView.snp.makeConstraints {
            $0.top.equalTo(itemCountContainerView.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(22)
            $0.bottom.equalToSuperview().offset(-6)
        }
    }

    private func setEventCollectionViewLayout() {
        eventCollectionView.delegate = self
        view.addSubview(eventCollectionView)
        
        eventCollectionView.register(
            EventCell.self,
            forCellWithReuseIdentifier: EventCell.identifier
        )
        
        eventCollectionView.snp.makeConstraints {
            $0.top.equalTo(divideLine.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: - FilterCOllectionView datasource설정
extension EventVC {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<FilterCell, FilterItem> { cell, _, item in
            cell.configure(tag: item.name, type: item.type)
        }
        
        dataSource = DataSource(collectionView: filterCollectionView) { (
            collectionView: UICollectionView,
            indexPath: IndexPath,
            identifier: FilterItem
        ) -> UICollectionViewCell? in return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: identifier
            )
        }
        
        var snapshot = Snapshot()
        let currentFilter = viewModel.getCurrentFilter()
        let selectedFilters = currentFilter.combinedStrings
        snapshot.appendSections([0])
        snapshot.appendItems(selectedFilters, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
        
        let isFilterCollectionViewHidden = selectedFilters.isEmpty
        filterCollectionView.isHidden = isFilterCollectionViewHidden
        
        divideLine.snp.updateConstraints {
            $0.top.equalTo(filterContainerView.snp.bottom)
                .offset(isFilterCollectionViewHidden ? -22 : 0)
        }
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100
),
            heightDimension: .absolute(22)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(5),
            top: .fixed(0),
            trailing: .fixed(5),
            bottom: .fixed(0)
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(1000),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 17,
            bottom: 0,
            trailing: 17
        )
        
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: createLayoutConfiguration())
        return layout
    }
    
    private func createLayoutConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        return configuration
    }
}

// MARK: - collectionView delegate
extension EventVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EventCell.identifier,
            for: indexPath
        ) as? EventCell ?? EventCollectionViewCell()
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if collectionView == filterCollectionView {
            guard
                let cell = filterCollectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell,
                let type = cell.type,
                let tagName = cell.tagLabel.text
            else { return }
            viewModel.deleteFilter(type: type, name: tagName)
        } else {
            
        }
    }
}

extension EventVC: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return collectionView.frame.size
    }
}

// MARK: - 캐러셀 메뉴를 위한 scrollView delegate
extension EventVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleIndexPaths = eventCollectionView.indexPathsForVisibleItems
        if let indexPath = visibleIndexPaths.first {
            let row = indexPath.row
            updateCategory(index: row)
        }
    }
}

// MARK: - binding

extension EventVC {
    private func setupCollectionViewBindings() {
        viewModel
            .combinedEvents
            .bind(
                to: eventCollectionView.rx.items(
                    cellIdentifier: EventCell.identifier,
                    cellType: EventCell.self
                )) {_, events, cell in
                    cell.configure(with: events)
                    cell.delegate = self
                    cell.tableView.reloadData()
                }
                .disposed(by: disposeBag)
        
        viewModel.filterObservable
            .subscribe(onNext: { [weak self] newFilter in
                let combinedStrings = newFilter.combinedStrings
                self?.configureDataSource()
            })
            .disposed(by: disposeBag)
        
        viewModel.curEventObservable
            .subscribe(onNext: { [weak self] events in
                self?.itemCountContainerView.setCount(count: events.count)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - filterVC에서 data 전달 위한 Delegate
extension EventVC: DataTransferDelegate {
    func dataTransfered(data: Any) {
        guard let data = data as? EventFilter else { return }
        viewModel.updateFilter(data)
    }
}

// MARK: - 이벤트 상세에서 bookMark 상태 변경
extension EventVC: EventScrapDelegate {
    func scrapStateChanged() {
        viewModel.updateEvents()
    }
}

extension EventVC: EventCollectionViewDelegate {
    func showEvent(event: EventResponseDTO) {
        let nextVC = EventDetailViewController()
        nextVC.delegate = self
        nextVC.setViewModel(event: event, isScrapped: viewModel.isScrapped(eventId: event.id))
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
