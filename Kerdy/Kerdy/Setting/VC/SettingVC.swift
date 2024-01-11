//
//  SettingVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 10/31/23.
//

import UIKit

import RxSwift
import RxDataSources

final class SettingVC: BaseVC {
    
    // MARK: - Property
    
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<SettingSectionItem.Model>
    
    private var dataSource: DataSource!
    private let viewModel: SettingViewModel
    private var authType: AlertType?
    
    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout())
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let authView =  PopUpView()
    
    // MARK: - Init
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MAKR: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRegisteration()
        setLayout()
        setDataSource()
        setDelegate()
        setBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setting

extension SettingVC {
    
    private func setRegisteration() {
        
        collectionView.register(SettingProfileCell.self, forCellWithReuseIdentifier: SettingProfileCell.identifier)
        collectionView.register(SettingBasicCell.self, forCellWithReuseIdentifier: SettingBasicCell.identifier)
    }
    
    private func setLayout() {
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(safeArea)
        }
    }
    
    private func setDelegate() {
        
        authView.delegate = self
    }
    
    private func setBindings() {
        
        let input = SettingViewModel.Input(viewWillAppear: rx.viewWillAppear.asDriver())
        let output = viewModel.transform(input: input)
        
        output.settingList
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .filter { $0.section == 1 }
            .bind { indexPath in
                var vc: UIViewController?

                switch indexPath.item {
                case 0:
                    vc = NotificationVC(viewModel: NotificationViewModel(tagManager: TagManager.shared))
                case 1:
                    vc = BlockListVC(viewModel: BlockListViewModel(blockManager: BlockManager.shared))
                case 2:
                    vc = TermsOfUseVC()
                case 4:
                    self.showPopupView(alert: self.authView, type: .withdrawal)
                    self.authType = .withdrawal
                case 5:
                    self.showPopupView(alert: self.authView, type: .logout)
                    self.authType = .logout
                default:
                    break
                }

                if let viewController = vc {
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - DataSource

extension SettingVC {
    
    func setDataSource() {
        
        dataSource = DataSource { [weak self] _, collectionView, indexPath, item in
            guard let self else { return UICollectionViewCell() }
            switch item {
            case let .profile(item):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SettingProfileCell.identifier,
                    for: indexPath
                ) as? SettingProfileCell else { return UICollectionViewCell() }
                cell.configureData(to: item)
                self.configureButton(cell: cell)
                return cell
                
            case let .basic(item):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SettingBasicCell.identifier,
                    for: indexPath
                ) as? SettingBasicCell else { return UICollectionViewCell() }
                cell.configureData(with: item, at: indexPath.item)
                return cell
            }
        }
    }
    
    func layout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self else { return nil }
            guard let section = SettingSectionItem.Section(rawValue: sectionIndex) else { return nil }
            switch section {
            case .profile:
                let itemGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                           heightDimension: .absolute(195))
                let item = NSCollectionLayoutItem(layoutSize: itemGroupSize)
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: itemGroupSize,
                                                             subitem: item,
                                                             count: 1)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 0, bottom: 14, trailing: 0)
                return section
                
            case .basic:
                var config = UICollectionLayoutListConfiguration(appearance: .plain)
                config.showsSeparators = false
                let section = NSCollectionLayoutSection.list(using: config,
                                                             layoutEnvironment: layoutEnvironment)
                return section
            }
        }
    }
}

extension SettingVC {
    
    private func showPopupView(alert: PopUpView, type: AlertType) {
        alert.configureTitle(title: type.title, subTitle: type.subTitle, unlock: type.button)
        
        view.addSubview(alert)
        alert.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureButton(cell: SettingProfileCell) {
        
        cell.rx.comment
            .asDriver()
            .drive(with: self) { owner, _ in
                let nextVC = SettingCommentsVC(viewModel: SettingCommenetViewModel(commentManager: CommentManager.shared))
                owner.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: cell.disposeBag)
    }
}

// MARk: - PopUp Delegate

extension SettingVC: PopUptoBlockDelegate {
    
    func action(blockID: Int) {
        
        guard let authType = self.authType else { return }
        self.viewModel.authMember(type: authType)
        
        SceneDelegate.shared?.changeRootViewControllerTo(AuthVC(viewModel: AuthViewModel(loginManager: LoginManager.shared)))
    }
    
    func cancel() {
        
        self.authView.removeFromSuperview()
    }
}
