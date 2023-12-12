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
    
    private var isSelected: Bool = true
    private let isSelectedRelay = BehaviorRelay<Bool>(value: false)
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
    
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: layout())
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
        setUI()
        setDataSource()
        bind()
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
    
    func setUI() {
        
        navigationBar.delegate = self
        popupView.delegate = self
    }
    
    func bind() {
        
        let input = BlockListViewModel.Input(viewWillAppear: rx.viewWillAppear.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.blockList
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        Observable.zip(isSelectedRelay, indexPath)
            .subscribe { isSecelted, indexPath in
                
                if let cell = self.collectionView.cellForItem(at: IndexPath(item: indexPath, section: 0)) as? BlockListCell {
                    cell.configureButton(isTapped: !isSecelted)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension BlockListVC {
    
    private func setRegisteration() {
        
        collectionView.register(BlockListCell.self, forCellWithReuseIdentifier: BlockListCell.identifier)
    }
    
    private func setDataSource() {
        
        dataSource = DataSource { [weak self] _, collectionView, indexPath, item in
            guard self != nil else { return UICollectionViewCell() }
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
    
    func tapBlockButton(memberID: Int, blockID: Int, indexPath: Int) {
        self.indexPath.accept(indexPath)
        
        if self.isSelected {
            showPopupView(blockID: blockID)
        } else {
            viewModel.postBlock(id: memberID)
            isSelectedRelay.accept(true)
            isSelected.toggle()
        }
    }
}

// MARK: - Navi BackButton Delegate

extension BlockListVC: BackButtonActionProtocol {
    
    func backButtonTapped() {
        
        self.navigationController?.popViewController(animated: true)
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
        self.isSelected = isSelected
        self.isSelectedRelay.accept(isSelected)
        
        self.popupView.removeFromSuperview()
        if let blockID = blockID {
            self.viewModel.deleteBlock(id: blockID)
        }
    }
}
