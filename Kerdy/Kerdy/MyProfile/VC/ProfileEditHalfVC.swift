//
//  ProfileEditHalfVC.swift
//  Kerdy
//
//  Created by 최다경 on 12/23/23.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileEditHalfVC: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.isScrollEnabled = true
        return sv
    }()
    
    private lazy var scrollContentView = UIView()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    
    private var dataSource: DataSource?
    
    private var viewModel = ProfileViewModel()
    
    var disposeBag = DisposeBag()
    
    private lazy var interestingLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 가테고리"
        label.font = .nanumSquare(to: .bold, size: 16)
        return label
    }()
    
    private lazy var selectLabel: UILabel = {
        let label = UILabel()
        label.text = "최대 2개까지 선택 가능합니다."
        label.font = .nanumSquare(to: .regular, size: 12)
        label.textColor = .kerdyGray04
        return label
    }()
    
    private lazy var addBtn: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .nanumSquare(to: .regular, size: 16)
        button.backgroundColor = .kerdyMain
        button.layer.cornerRadius = 15
        button.setTitle("추가하기", for: .normal)
        button.addTarget(self, action: #selector(addBtnTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        configureDataSource()
        bindViewModel()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        scrollView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
    }
    
    private func setLayout() {
        
        view.addSubviews(
            interestingLabel,
            selectLabel,
            addBtn,
            scrollView
        )
        
        scrollView.addSubview(scrollContentView)
        
        scrollContentView.addSubview(collectionView)
        
        interestingLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.leading.equalToSuperview().offset(17)
            $0.top.equalToSuperview().offset(49)
        }
        
        selectLabel.snp.makeConstraints {
            $0.height.equalTo(14)
            $0.leading.equalToSuperview().offset(17)
            $0.top.equalTo(interestingLabel.snp.bottom).offset(10)
        }
        
        addBtn.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-17)
            $0.bottom.equalToSuperview().offset(-25)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(selectLabel.snp.bottom).offset(25)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(addBtn.snp.top).offset(-10)
        }
        
        scrollContentView.snp.makeConstraints {
            $0.height.equalTo(scrollView.snp.height).priority(250)
            $0.width.equalTo(view.bounds.width)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(17)
            $0.verticalEdges.equalTo(scrollContentView.snp.verticalEdges)
        }
        
    }
    
    @objc func addBtnTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

}

extension ProfileEditHalfVC {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProfileTagCell, String> {
            cell, indexPath, itemIdentifier in
            let tag = self.viewModel.dummy[indexPath.row]
            let isSelected = self.viewModel.selectedTechs.value.contains(tag)
            cell.confiure(tag: tag)
            cell.setBackgroundColor(isSelected: isSelected)
            
        }
        
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: identifier
            )
        }
        
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.dummy, toSection: 0)
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
    
    private func updateCollectionView(with tags: [String]) {
        
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.dummy, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - collectionView delegate
extension ProfileEditHalfVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileTagCell else { return }
        let selectedTag = viewModel.dummy[indexPath.row]
        let isSelected = viewModel.toggleSelectedTag(tag: selectedTag)
        cell.setBackgroundColor(isSelected: isSelected)
    }
}

// MARK: - binding

extension ProfileEditHalfVC {
    private func bindViewModel() {
        viewModel.techSectionData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] tags in
                self?.updateCollectionView(with: tags)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - scrollView delegate
extension ProfileEditHalfVC: UIScrollViewDelegate {
    
}
