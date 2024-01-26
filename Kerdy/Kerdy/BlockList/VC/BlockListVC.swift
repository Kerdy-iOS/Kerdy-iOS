//
//  BlockListVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import UIKit

import Core
import SnapKit

import RxSwift
import RxCocoa
import RxDataSources

final class BlockListVC: BaseVC {
    
    // MAKR: - Property
    
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<BlockSection>
    
    private var dataSource: DataSource!
    private var viewModel: BlockListViewModel
    private let indexPath = BehaviorRelay<Int>(value: 0)
    
    // MAKR: - UI Property
    
    private let navigationBar: NavigationBarView = {
        let view = NavigationBarView()
        view.configureUI(to: Strings.blockTitle)
        return view
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.blockSubTitle
        label.font = .nanumSquare(to: .regular, size: 11)
        label.textColor = .kerdyGray02
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private let popupView: PopUpView = {
        let view = PopUpView()
        view.configureTitle(title: Strings.unblock,
                            subTitle: Strings.alertUnlockTitle,
                            unlock: Strings.alertUnlock)
        return view
    }()
    
    // MARK: - Life Cycle
    
    init(viewModel: BlockListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRegisteration()
        setLayout()
        setDelegate()
        setDataSource()
        setBindings()
    }
}

// MARK: - Methods

private extension BlockListVC {
    
    func setLayout() {
        
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeArea)
        }
        
        view.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(8)
            $0.centerX.equalTo(safeArea)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalTo(safeArea)
            $0.bottom.equalToSuperview()
        }
    }
    
    func setDelegate() {
        
        navigationBar.delegate = self
        popupView.delegate = self
    }
    
    func setBindings() {
        
        let input = BlockListViewModel.Input(viewWillAppear: rx.viewWillAppear.asDriver())
        
        let output = viewModel.transform(input: input)
        output.blockList
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension BlockListVC {
    
    private func setRegisteration() {
        
        collectionView.register(BlockListCell.self, forCellWithReuseIdentifier: BlockListCell.identifier)
    }
    
    private func setDataSource() {
        
        dataSource = DataSource { [weak self] _, collectionView, indexPath, item in
            guard let self else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BlockListCell.identifier,
                for: indexPath
            ) as? BlockListCell else { return UICollectionViewCell() }
            
            cell.configureCell(to: item, indexPath: indexPath.item)
            cell.delegate = self
            
            return cell
        }
    }
    
    func layout() -> UICollectionViewLayout {
        
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
}

// MARK: - Navi BackButton Delegate

extension BlockListVC: BackButtonActionProtocol {
    
    func backButtonTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - PopUptoBlockDelegate

extension BlockListVC: PopUptoBlockDelegate {
    
    func action(blockID: Int) {
        
        removePopupView(blockID: blockID, isSelected: false)
    }
    
    func cancel() {
        
        removePopupView(blockID: nil, isSelected: true)
    }
}

// MARK: - Block Cell Delegate

extension BlockListVC: BlockCellDelegate {
    
    func tapBlockButton(indexPath: Int) {
        
        self.indexPath.accept(indexPath)
        guard let item = self.viewModel.cellInfo(index: indexPath) else { return }
        
        if item.isSelected {
            self.showPopupView(blockID: item.id)
        } else {
            viewModel.postBlock(id: item.memberID)
            self.viewModel.updateSelectedItem(index: indexPath, isSelected: true)
        }
    }
}

// MARK: - Show Popup View

extension BlockListVC {
    
    private func showPopupView(blockID: Int) {
        
        popupView.configureBlockID(id: blockID)
        
        view.addSubview(popupView)
        popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func removePopupView(blockID: Int? = nil, isSelected: Bool) {
        
        let indexPath = self.indexPath.value
        self.viewModel.updateSelectedItem(index: indexPath, isSelected: isSelected)
        self.viewModel.delegeBlockMember(blockID: blockID)
        self.popupView.removeFromSuperview()
    }
}
