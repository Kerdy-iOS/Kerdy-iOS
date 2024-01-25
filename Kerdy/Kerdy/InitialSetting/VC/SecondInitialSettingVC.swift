//
//  SecondInitialSettingVC.swift
//  Kerdy
//
//  Created by 최다경 on 11/3/23.
//

import UIKit
import Core
import RxSwift
import RxCocoa

final class SecondInitialSettingVC: UIViewController {
    
    private let viewModel = InitialSettingViewModel.shared
    
    private let disposeBag = DisposeBag()
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, ActivityResponse>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, ActivityResponse>
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.isScrollEnabled = true
        return sv
    }()
    
    private lazy var scrollContentView = UIView()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    
    private var dataSource: DataSource?
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.text = "2/4"
        label.font = .nanumSquare(to: .regular, size: 14)
        label.textColor = .kerdyMain
        return label
    }()
    
    private lazy var interestingPartLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 분야"
        label.font = .nanumSquare(to: .regular, size: 14)
        return label
    }()
    
    private lazy var interestingCategoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "관심 있는 카테고리를\n선택해주세요."
        label.font = .nanumSquare(to: .regular, size: 20)
        return label
    }()
    
    private lazy var notifyLabel: UILabel = {
        let label = UILabel()
        label.text = "복수 선택이 최대 4개까지 가능합니다"
        label.font = .nanumSquare(to: .regular, size: 13)
        label.textColor = .kerdyGray04
        return label
    }()
    
    private lazy var nextBtn: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .nanumSquare(to: .regular, size: 16)
        button.backgroundColor = .kerdyMain
        button.layer.cornerRadius = 15
        button.setTitle("다음", for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setUI()
        setLayout()
        setNaviBar()
        configureDataSource()
        bindViewModel()
    }
    
    private func setLayout() {
        view.addSubviews(
            progressLabel,
            interestingPartLabel,
            interestingCategoryLabel,
            notifyLabel,
            nextBtn,
            scrollView
        )
        
        scrollView.addSubview(scrollContentView)
        
        scrollContentView.addSubview(collectionView)
        
        progressLabel.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(16)
            $0.top.equalToSuperview().offset(97)
            $0.leading.equalToSuperview().offset(21)
        }
        
        interestingPartLabel.snp.makeConstraints {
            $0.width.equalTo(55)
            $0.height.equalTo(16)
            $0.top.equalToSuperview().offset(121)
            $0.leading.equalToSuperview().offset(21)
        }
        
        interestingCategoryLabel.snp.makeConstraints {
            $0.width.equalTo(174)
            $0.height.equalTo(50)
            $0.top.equalToSuperview().offset(174)
            $0.leading.equalToSuperview().offset(21)
        }
        
        notifyLabel.snp.makeConstraints {
            $0.width.equalTo(202)
            $0.height.equalTo(15)
            $0.top.equalToSuperview().offset(234)
            $0.leading.equalToSuperview().offset(21)
        }
        
        nextBtn.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalToSuperview().offset(675)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-17)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(277.5)
            $0.leading.equalToSuperview().offset(21)
            $0.trailing.equalToSuperview().offset(-21)
            $0.bottom.equalTo(nextBtn.snp.top).offset(-10)
        }
        
        scrollContentView.snp.makeConstraints {
            $0.height.equalTo(scrollView.snp.height).priority(250)
            $0.width.equalTo(view.bounds.width)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalTo(scrollContentView.snp.verticalEdges)
        }
    }
    
    private func setNaviBar() {
        navigationController?.navigationBar.tintColor = .kerdyGray01
        navigationItem.backButtonTitle = ""
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        scrollView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
    }
    
    @objc private func nextButtonTapped() {
        let nextVC = ThirdInitialSettingVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension SecondInitialSettingVC {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProfileTagCell, ActivityResponse> { cell, indexPath, itemIdentifier in
            let activity: ActivityResponse
            activity = self.viewModel.jobActivities.value[indexPath.row]
            
            
            let isSelected = self.viewModel.selectedCategory.value.contains(activity.id)
            cell.confiure(tag: activity.name)
            cell.setBackgroundColor(isSelected: isSelected)
        }
        
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: ActivityResponse) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: identifier
            )
        }
        
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.jobActivities.value, toSection: 0)
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
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func updateCollectionView(with activities: [ActivityResponse]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(activities, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - collectionView delegate
extension SecondInitialSettingVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileTagCell else { return }
        let selectedActivity: ActivityResponse
        selectedActivity = viewModel.jobActivities.value[indexPath.row]
        
        let isSelected = viewModel.toggleSelectedCategory(id: selectedActivity.id)
        cell.setBackgroundColor(isSelected: isSelected)
        
        if viewModel.selectedCategory.value.count  > 4 {
            viewModel.toggleSelectedCategory(id: selectedActivity.id)
            cell.setBackgroundColor(isSelected: !isSelected)
        }
    }
}

// MARK: - binding

extension SecondInitialSettingVC {
    private func bindViewModel() {
        viewModel.getAllActivities()
        viewModel.jobActivities
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] activities in
                self?.updateCollectionView(with: activities)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - scrollView delegate
extension SecondInitialSettingVC: UIScrollViewDelegate {
    
}
