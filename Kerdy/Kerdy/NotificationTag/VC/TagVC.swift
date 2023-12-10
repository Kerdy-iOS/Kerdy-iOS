//
//  TagVC.swift
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

final class TagVC: BaseVC {
    
    // MARK: - Property
    
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<TagSection>
    
    private var dataSource: DataSource!
    private let viewModel: TagViewModel
    
    private var selectedTag = [Int]()
    
    // MARK: - UI Property
    
    private let navigationView: NavigationBarView = {
        let view = NavigationBarView()
        view.configureUI(to: Strings.notificationTag)
        return view
    }()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: TagCollectionViewFlowLayout())
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.tag
        label.font = .nanumSquare(to: .bold, size: 15)
        label.textColor = .kerdyBlack
        return label
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.register, for: .normal)
        button.makeCornerRound(radius: 15)
        button.backgroundColor = .kerdyMain
        return button
    }()
    
    // MARK: - Life Cycle
    
    init(viewModel: TagViewModel) {
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

extension TagVC {
    
    private func setRegisteration() {
        
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
    }
    
    private func setLayout() {
        
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeArea)
        }
        
        view.addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(20)
            $0.leading.equalTo(safeArea).inset(17)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(tagLabel.snp.bottom).offset(14)
            $0.horizontalEdges.equalTo(safeArea).inset(17)
            $0.bottom.equalTo(safeArea)
        }
        
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(safeArea).inset(17)
            $0.height.equalTo(60)
        }
        
    }
    
    private func setUI() {
        
        navigationView.delegate = self
        collectionView.allowsMultipleSelection = true
    }
    
    private func bind() {
        let input = TagViewModel.Input(viewWillAppear: rx.viewWillAppear.asDriver(),
                                       tapRegisterButton: registerButton.rx.tap.asSignal())
        
        let output = viewModel.transform(input: input)
        
        output.tagList
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.modelDeselected(TagsResponseDTO.self)
            .bind { model in
                self.selectedTag.removeAll { $0 == model.id }
                self.viewModel.selectTags(id: self.selectedTag)
            }
            .disposed(by: disposeBag)
        
        Observable
            .zip(collectionView.rx.itemSelected,
                 collectionView.rx.modelSelected(TagsResponseDTO.self))
            .bind { indexPath, model in
                guard let cell = self.collectionView.cellForItem(at: indexPath) as? TagCell else { return }
                cell.configureBackground()
                self.selectedTag.append(model.id)
                self.viewModel.selectTags(id: self.selectedTag)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - DataSource

extension TagVC {
    
    func setDataSource() {
        
        dataSource = DataSource { [weak self] _, collectionView, indexPath, item in
            guard self != nil else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TagCell.identifier,
                for: indexPath
            ) as? TagCell else { return UICollectionViewCell() }
            cell.configureCell(to: item, tagType: .registerTag)
            return cell
        }
    }
}

// MARK: - BackButtonActionProtocol

extension TagVC: BackButtonActionProtocol {
    
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TagVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let dataSource = dataSource else { return .zero }
        let width = dataSource[indexPath.section].items[indexPath.item].name
        return width.insetSize()
    }
}
