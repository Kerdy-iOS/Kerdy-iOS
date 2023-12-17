//
//  NotificationVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/1/23.
//

import UIKit

import Core
import SnapKit

import RxSwift
import RxCocoa
import RxDataSources

final class NotificationVC: BaseVC {
    
    // MARK: - Property
    
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<TagSection>
    
    private var dataSource: DataSource!
    private let viewModel: NotificationViewModel
    
    // MARK: - UI Property
    
    private let navigationBar: NavigationBarView = {
        let view = NavigationBarView()
        view.configureUI(to: Strings.notificationTitle)
        return view
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdyGray01
        return view
    }()
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.notification
        label.font = .nanumSquare(to: .regular, size: 14)
        label.textColor = .kerdyBlack
        return label
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.notificationTag
        label.font = .nanumSquare(to: .bold, size: 15)
        label.textColor = .kerdyBlack
        label.setLineSpacing(lineSpacing: 1.15)
        return label
    }()
    
    private let tagSubLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.subTag
        label.font = .nanumSquare(to: .regular, size: 11)
        label.textColor = .kerdyGray02
        return label
    }()
    
    private lazy var switchButton: UISwitch = {
        let button = UISwitch()
        button.onTintColor = .kerdyMain
        button.tintColor = .kerdyGray01
        button.thumbTintColor = .kerdyBackground
        button.setSize(width: 36, height: 20)
        return button
    }()
    
    private let addButton: UIButton = {
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
    
    // MARK: - Init
    
    init(viewModel: NotificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRegisteration()
        setLayout()
        setUI()
        setDataSource()
        bind()
    }
}

// MARK: = Methods

extension NotificationVC {
    
    private func setRegisteration() {
        
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
    }
    
    private func setLayout() {
        
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeArea)
        }
        
        view.addSubview(notificationLabel)
        notificationLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(23)
            $0.leading.equalTo(safeArea).inset(17)
        }
        
        view.addSubview(switchButton)
        switchButton.snp.makeConstraints {
            $0.centerY.equalTo(notificationLabel.snp.centerY)
            $0.trailing.equalTo(safeArea).inset(17)
        }
        
        view.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.top.equalTo(notificationLabel.snp.bottom).offset(23)
            $0.horizontalEdges.equalTo(safeArea)
            $0.height.equalTo(0.5)
        }
        
        view.addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(25)
            $0.leading.equalTo(safeArea).inset(17)
        }
        
        view.addSubview(tagSubLabel)
        tagSubLabel.snp.makeConstraints {
            $0.top.equalTo(tagLabel.snp.bottom).offset(14)
            $0.leading.equalTo(safeArea).inset(17)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(tagSubLabel.snp.bottom).offset(22)
            $0.horizontalEdges.bottom.equalTo(safeArea).inset(17)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.top.equalTo(tagSubLabel.snp.bottom).offset(22)
            $0.leading.equalTo(safeArea).inset(17)
            $0.size.equalTo(CGSize(width: 60, height: 32))
        }
    }
    
    private func setUI() {
        
        navigationBar.delegate = self
    }
}

// MARK: - Navi BackButton Delegate

extension NotificationVC: BackButtonActionProtocol {
    
    func backButtonTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func bind() {
        
        let input = NotificationViewModel.Input(viewWillAppear: rx.viewWillAppear.asDriver())
        let output = viewModel.transform(input: input)
        
        output.tagList
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.navigationController?.pushViewController(TagVC(viewModel: TagViewModel(tagManager: TagManager.shared)), animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - DataSource

extension NotificationVC {
    
    func setDataSource() {
        
        dataSource = DataSource { [weak self] _, collectionView, indexPath, item in
            guard self != nil else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TagCell.identifier,
                for: indexPath
            ) as? TagCell else { return UICollectionViewCell() }
            
            cell.configureCell(to: item, tagType: .userTag)
            
            cell.rx.cancel.asSignal()
                .throttle(.milliseconds(500))
                .map { item.id }
                .emit { [weak self] id in
                    guard let self else { return }
                    self.viewModel.deleteTags(id: [id])
                }
                .disposed(by: cell.disposeBag)
            
            return cell
        }
    }
}

// MARK: - CollectionView Layout

extension NotificationVC {
    
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
