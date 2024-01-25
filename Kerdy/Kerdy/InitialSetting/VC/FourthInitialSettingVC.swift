//
//  FourthInitialSettingVC.swift
//  Kerdy
//
//  Created by 최다경 on 11/4/23.
//

import UIKit
import Core
import RxSwift

final class FourthInitialSettingVC: UIViewController {
    
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
        label.text = "4/4"
        label.font = .nanumSquare(to: .regular, size: 14)
        label.textColor = .kerdyMain
        return label
    }()
    
    private lazy var clubActivityLabel: UILabel = {
        let label = UILabel()
        label.text = "동아리 활동"
        label.font = .nanumSquare(to: .regular, size: 14)
        return label
    }()
    
    private lazy var askClubActivityLabel: UILabel = {
        let label = UILabel()
        label.text = "동아리 활동이 있나요?"
        label.font = .nanumSquare(to: .regular, size: 20)
        return label
    }()
    
    private lazy var notifyLabel: UILabel = {
        let label = UILabel()
        label.text = "동아리 활동을 했다면 추가해 주세요."
        label.font = .nanumSquare(to: .regular, size: 13)
        label.textColor = .kerdyGray04
        return label
    }()
    
    private lazy var enterLaterBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("나중에 입력하기", for: .normal)
        button.setTitleColor(.kerdyGray02, for: .normal)
        button.titleLabel?.font = .nanumSquare(to: .regular, size: 15)
        button.addTarget(self, action: #selector(enterLaterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var enterLaterBtnUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray02
        return view
    }()
    
    private lazy var doneBtn: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .nanumSquare(to: .regular, size: 16)
        button.backgroundColor = .kerdyMain
        button.layer.cornerRadius = 15
        button.setTitle("완료", for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setNaviBar()
        configureDataSource()
        bindViewModel()
    }
    
    private func setLayout() {
        view.addSubviews(
            progressLabel,
            clubActivityLabel,
            askClubActivityLabel,
            notifyLabel,
            doneBtn,
            enterLaterBtn,
            enterLaterBtnUnderLine,
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
        
        clubActivityLabel.snp.makeConstraints {
            $0.width.equalTo(68)
            $0.height.equalTo(16)
            $0.top.equalToSuperview().offset(121)
            $0.leading.equalToSuperview().offset(21)
        }
        
        askClubActivityLabel.snp.makeConstraints {
            $0.width.equalTo(185)
            $0.height.equalTo(23)
            $0.top.equalToSuperview().offset(174)
            $0.leading.equalToSuperview().offset(21)
        }
        
        notifyLabel.snp.makeConstraints {
            $0.width.equalTo(194)
            $0.height.equalTo(15)
            $0.top.equalToSuperview().offset(207)
            $0.leading.equalToSuperview().offset(21)
        }
        
        doneBtn.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalToSuperview().offset(675)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-17)
        }
        
        enterLaterBtn.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(17)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(641)
        }
        
        enterLaterBtnUnderLine.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(1.5)
            $0.top.equalToSuperview().offset(657)
            $0.leading.equalTo(enterLaterBtn.snp.leading)
            $0.trailing.equalTo(enterLaterBtn.snp.trailing)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(277.5)
            $0.leading.equalToSuperview().offset(21)
            $0.trailing.equalToSuperview().offset(-21)
            $0.bottom.equalTo(enterLaterBtn.snp.top).offset(-10)
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
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        scrollView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
    }
    
    private func setNaviBar() {
        navigationController?.navigationBar.tintColor = .kerdyGray01
        navigationItem.backButtonTitle = ""
    }
    
    @objc private func enterLaterButtonTapped() {
        let selectedIds = viewModel.selectedCategory.value + viewModel.selectedActivities.value
        viewModel.postInitialMember(ids: selectedIds, name: viewModel.userName)
            .subscribe(
                onCompleted: { [weak self] in
                    let tabBarController = TabBarVC()
                    SceneDelegate.shared?.changeRootViewControllerTo(tabBarController)
                },
                onError: { error in
                    print(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    @objc private func doneButtonTapped() {
        let selectedIds = viewModel.selectedCategory.value + viewModel.selectedActivities.value
        viewModel.postInitialMember(ids: selectedIds, name: viewModel.userName)
            .subscribe(
                onCompleted: { [weak self] in
                    let tabBarController = TabBarVC()
                    SceneDelegate.shared?.changeRootViewControllerTo(tabBarController)
                },
                onError: { error in
                    print(error)
                }
            )
            .disposed(by: disposeBag)
    }
}

extension FourthInitialSettingVC {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProfileTagCell, ActivityResponse> { cell, indexPath, itemIdentifier in
            let activity: ActivityResponse
            activity = self.viewModel.clubActivities.value[indexPath.row]
            
            
            let isSelected = self.viewModel.selectedActivities.value.contains(activity.id)
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
        snapshot.appendItems(viewModel.clubActivities.value, toSection: 0)
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
extension FourthInitialSettingVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileTagCell else { return }
        let selectedActivity: ActivityResponse
        selectedActivity = viewModel.clubActivities.value[indexPath.row]
        
        let isSelected = viewModel.toggleSelectedTag(id: selectedActivity.id)
        cell.setBackgroundColor(isSelected: isSelected)
    }
}

// MARK: - binding

extension FourthInitialSettingVC {
    private func bindViewModel() {
        viewModel.clubActivities
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] activities in
                self?.updateCollectionView(with: activities)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - scrollView delegate
extension FourthInitialSettingVC: UIScrollViewDelegate {
    
}
