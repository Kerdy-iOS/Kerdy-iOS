//
//  ModalVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 1/11/24.
//

import UIKit

import Core

import RxSwift
import RxDataSources

protocol ModalProtocol: AnyObject {
    
    func dismiss(type: AlertType, indexPath: IndexPath)
}

final class ModalVC: UIViewController {
    
    // MARK: - Property
    
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<CommonModalSectionItem.Model>
    
    private var dataSource: DataSource!
    private let viewModel: CommonModalViewModel
    private let disposeBag = DisposeBag()
    private var type: AlertType?
    weak var delegate: ModalProtocol?
    
    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout())
        collectionView.bounces = false
        collectionView.makeCornerRound(radius: 15)
        collectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let popupView =  PopUpView()
    
    // MARK: - init
    
    init(viewModel: CommonModalViewModel) {
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
        setDelegate()
        setBindings()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first!
        let location = touch.location(in: self.view)
        
        if !collectionView.frame.contains(location) {
            view.backgroundColor = .clear
            dismiss(animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension ModalVC {
    
    private func setRegisteration() {
        
        collectionView.register(CommonModalCell.self, forCellWithReuseIdentifier: CommonModalCell.identifier)
    }
    
    private func setLayout() {
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.height.equalTo(300)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    private func setUI() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            UIView.animate(withDuration: 0.5) {
                self.view.backgroundColor = .kerdyBlack.withAlphaComponent(0.6)
            }
        }
    }
    
    private func setDelegate() {
        
        popupView.delegate = self
    }
    
    private func setBindings() {
        
        let input = CommonModalViewModel.Input(viewWillAppear: rx.viewWillAppear.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.modalList
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.modalHeight
            .drive(with: self) { owner, height in
                owner.updateCollectionViewHeight(height)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(CommonModalSectionItem.Item.self)
            .asDriver()
            .drive(with: self) { owner, item in
                switch item {
                case .report:
                    owner.type = .report
                    owner.showPopupView(alert: owner.popupView, type: .report )
                    owner.updateCollectionViewHeight(0)
                case .basic(let basicItem):
                    if basicItem.type == .modify {
                        owner.dissmissVC()
                        guard let index = basicItem.index else { return }
                        owner.delegate?.dismiss(type: .modify, indexPath: index)
                    } else {
                        owner.type = .delete
                        owner.showPopupView(alert: owner.popupView, type: .delete)
                        owner.updateCollectionViewHeight(0)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func updateCollectionViewHeight(_ height: Int) {
        dump(height)
        collectionView.snp.updateConstraints {
            $0.height.equalTo(height*60)
        }
    }
}

// MARK: - DataSource

extension ModalVC {
    
    func setDataSource() {
        
        dataSource = DataSource { [weak self] _, collectionView, indexPath, item in
            guard let self else { return UICollectionViewCell() }
            switch item {
            case .report(let item), .basic(let item):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CommonModalCell.identifier,
                    for: indexPath
                ) as? CommonModalCell else { return UICollectionViewCell() }
                
                cell.configureData(to: item)
                
                return cell
            }
        }
    }
    
    func layout() -> UICollectionViewCompositionalLayout {
        
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = true
        config.separatorConfiguration.bottomSeparatorInsets = .zero
        config.separatorConfiguration.color = .kerdyGray01
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
}

extension ModalVC {
    
    private func showPopupView(alert: PopUpView, type: AlertType) {
        alert.configureTitle(title: type.title, subTitle: type.subTitle, unlock: type.button)
        
        view.addSubview(alert)
        alert.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func dissmissVC() {
        self.view.backgroundColor = .clear
        self.dismiss(animated: true)
    }
}

// MARk: - PopUp Delegate

extension ModalVC: PopUptoBlockDelegate {
    
    func action(blockID: Int) {
        
        guard let alertType = self.type else { return }
        self.viewModel.modalType(type: alertType )
        self.dissmissVC()
    }
    
    func cancel() {
        
        self.popupView.removeFromSuperview()
        self.dissmissVC()
    }
}
