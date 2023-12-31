//
//  FilterViewController.swift
//  Kerdy
//
//  Created by 이동현 on 11/3/23.
//

import UIKit
import RxSwift
import RxCocoa

enum FilterSection: Int {
    case progress
    case tag
    
    var stringValue: String {
        switch self {
        case .progress:
            return "진행 상태"
        case .tag:
            return "태그"
        }
    }
}
protocol DateSelecBtnDelegate: AnyObject {
    func dateBtnTapped(startDate: String?, endDate: String?)
}

final class FilterVC: BaseVC {
    typealias DataSource = UICollectionViewDiffableDataSource<FilterSection, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<FilterSection, String>
    
    private lazy var navigationBar: NavigationBarView = {
        let view = NavigationBarView()
        view.delegate = self
        return view
    }()
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = true
        return view
    }()
    private lazy var scrollContentView = UIView()
    private lazy var resetBtn = ResetBtn()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    private lazy var dateFilterView = DateFilterView()
    private lazy var applyBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .kerdyMain
        button.setTitle("적용하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .nanumSquare(to: .bold, size: 16)
        button.layer.cornerRadius = 15
        return button
    }()
    
    private var dataSource: DataSource?
    private var viewModel = FilterViewModel()
    weak var delegate: DataTransferDelegate?
    static private let headerId = FilterHeaderView.reuseIdentifier
    static private let footerId = FilterFooterView.reuseIdentifier
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setUI()
        configureDataSource()
        bindViewModel()
    }
    
    private func setUI() {
        scrollView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        resetBtn.addTarget(self, action: #selector(resetBtnTapped), for: .touchUpInside)
        applyBtn.addTarget(self, action: #selector(applyBtnTapped), for: .touchUpInside)
        
        for view in dateFilterView.dateStackView.subviews {
            if let btn = view as? DateSelectBtn {
                btn.addTarget(self, action: #selector(dateFilterBtnTapped), for: .touchUpInside)
            }
        }
    }
    
    @objc private func dateFilterBtnTapped() {
        let nextVC = DateFilterViewController()
        nextVC.delegate = self
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func resetBtnTapped() {
        viewModel.resetFilter()
        clearCells()
        dateFilterView.setDateLabelText(start: nil, end: nil)
    }
    
    @objc func applyBtnTapped() {
        let filter = viewModel.applyFilter()
        delegate?.dataTransfered(data: filter)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setViewModel(filter: EventFilter) {
        viewModel.setFilter(filter)
        
        var dates: [String] = []
        if let startDate = filter.startDate {
            dates.append(startDate)
        }
        if let endDate = filter.endDate {
            dates.append(endDate)
        }
        
        setDateUI(dates: dates)
    }
    
    private func setDateUI(dates: [String]) {
        switch dates.count {
        case 1:
            viewModel.setDate(startDate: dates.first, endDate: nil)
            dateFilterView.setDateLabelText(start: dates.first, end: nil)
        case 2:
            viewModel.setDate(startDate: dates.first, endDate: dates.last)
            dateFilterView.setDateLabelText(start: dates.first, end: dates.last)
        default:
            viewModel.setDate(startDate: nil, endDate: nil)
            dateFilterView.setDateLabelText(start: nil, end: nil)
        }
    }
}

// MARK: - layout 설정
extension FilterVC {
    private func setLayout() {
        view.addSubviews(
            navigationBar,
            resetBtn,
            scrollView
        )

        scrollView.addSubview(scrollContentView)

        scrollContentView.addSubviews(
            collectionView,
            dateFilterView,
            applyBtn
        )

        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }

        resetBtn.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(6)
            $0.trailing.equalToSuperview().offset(-17)
            $0.width.equalTo(74)
            $0.height.equalTo(14)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(resetBtn.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview()
            $0.width.equalTo(view.bounds.width)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        scrollContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(100).priority(250)
            $0.width.equalTo(view.bounds.width)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(17)
            $0.top.equalToSuperview()
            $0.height.equalTo(380)
        }
        
        dateFilterView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(collectionView.snp.bottom).offset(26)
            $0.height.equalTo(79)
        }

        applyBtn.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(17)
            $0.top.equalTo(dateFilterView.snp.bottom).offset(17).priority(500)
            $0.bottom.equalToSuperview().offset(-17)
            $0.height.equalTo(60)
        }
    }
    
    override func viewDidLayoutSubviews() {
        dateFilterView.setUI()
    }
}

// MARK: - collectionView datasource, layout 설정
extension FilterVC {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TagFilterCollectionViewCell, String> {
            cell, indexPath, itemIdentifier in
            switch indexPath.section {
            case FilterSection.progress.rawValue:
                let tag = self.viewModel.progressSectionData.value[indexPath.row]
                let isSelected = self.viewModel.selectedProgress.value.contains(tag)
                cell.confiure(tag: tag)
                cell.setBackgroundColor(isSelected: isSelected)
                
            case FilterSection.tag.rawValue:
                let tag = self.viewModel.techSectionData.value[indexPath.row]
                let isSelected = self.viewModel.selectedTechs.value.contains(tag)
                cell.confiure(tag: tag)
                cell.setBackgroundColor(isSelected: isSelected)
            default:
                print("error")
            }
        }
    
        let headerRegistration = UICollectionView.SupplementaryRegistration<FilterHeaderView>(elementKind: FilterVC.headerId) { supplementaryView, _, indexPath in
            switch indexPath.section {
            case FilterSection.progress.rawValue:
                supplementaryView.configure(title: FilterSection.progress.stringValue)
            case FilterSection.tag.rawValue:
                supplementaryView.configure(title: FilterSection.tag.stringValue)
            default:
                print("error")
            }
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration<FilterFooterView>(elementKind: FilterVC.footerId) { _, _, _ in
            
        }
        
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: identifier
            )
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == FilterVC.headerId {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: headerRegistration, for: indexPath)
            } else {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: footerRegistration, for: indexPath)
            }
        }
        
        var snapshot = Snapshot()
        snapshot.appendSections([.progress])
        snapshot.appendItems(viewModel.progressSectionData.value, toSection: .progress)
        snapshot.appendSections([.tag])
        snapshot.appendItems(viewModel.techSectionData.value, toSection: .tag)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(50),
            heightDimension: .estimated(32)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(0),
            top: .fixed(11),
            trailing: .fixed(5),
            bottom: .fixed(0)
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 4,
            leading: 0,
            bottom: 35,
            trailing: 0
        )
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .estimated(19))
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(26.5))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: FilterVC.headerId, alignment: .top)
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: FilterVC.footerId, alignment: .bottom)
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func updateCollectionView(with tags: [String]) {
        
        var snapshot = Snapshot()
        snapshot.appendSections([.progress])
        snapshot.appendItems(viewModel.progressSectionData.value, toSection: .progress)
        snapshot.appendSections([.tag])
        snapshot.appendItems(tags, toSection: .tag)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func clearCells() {
        collectionView.visibleCells.forEach { cell in
            guard let tagCell = cell as? TagFilterCollectionViewCell else { return }
            
            let indexPath = collectionView.indexPath(for: tagCell)
            
            if let section = indexPath?.section, let row = indexPath?.row {
                switch section {
                case FilterSection.progress.rawValue:
                    tagCell.setBackgroundColor(isSelected: false)
                case FilterSection.tag.rawValue:
                    tagCell.setBackgroundColor(isSelected: false)
                default:
                    break
                }
            }
            
            viewModel.resetFilter()
        }
    }
}

// MARK: - collectionView delegate
extension FilterVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TagFilterCollectionViewCell else { return }
        switch indexPath.section {
        case FilterSection.progress.rawValue:
            let selectedTag = viewModel.progressSectionData.value[indexPath.row]
            let isSelected = viewModel.toggleSelectedProgress(tag: selectedTag)
            cell.setBackgroundColor(isSelected: isSelected)
        case FilterSection.tag.rawValue:
            let selectedTag = viewModel.techSectionData.value[indexPath.row]
            let isSelected = viewModel.toggleSelectedTag(tag: selectedTag)
            cell.setBackgroundColor(isSelected: isSelected)
        default:
            break
        }
    }
}

// MARK: - binding

extension FilterVC {
    private func bindViewModel() {
        viewModel.techSectionData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] tags in
                self?.updateCollectionView(with: tags)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - 날짜 선택
extension FilterVC: DataTransferDelegate {
    func dataTransfered(data: Any) {
        guard let data = data as? [String] else { return }
        
        setDateUI(dates: data)
    }
}

// MARK: - back button delegate
extension FilterVC: BackButtonActionProtocol {
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - scrollView delegate
extension FilterVC: UIScrollViewDelegate {
    
}
