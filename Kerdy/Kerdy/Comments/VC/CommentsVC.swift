//
//  CommentsVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/17/23.
//

import UIKit

import Core
import SnapKit

import RxSwift
import RxDataSources
import RxKeyboard

final class CommentsVC: BaseVC {
    
    // MARK: = Property
    
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<CommentsSection>
    
    private var dataSource: DataSource!
    private let viewModel: CommentsViewModel
    
    // MARK: - UI Components
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout())
    
    private let navigationBar: NavigationBarView = {
        let view = NavigationBarView()
        view.configureUI(to: Strings.commentsTitle)
        return view
    }()
    
    private let textFieldView = CommentsContainerView()
    
    // MARK: - Init
    
    init(viewModel: CommentsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRegisteration()
        setLayout()
        setDelegate()
        setDataSource()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension CommentsVC {
    
    private func setRegisteration() {
        
        collectionView.register(ChildCommentsCell.self, forCellWithReuseIdentifier: ChildCommentsCell.identifier)
        collectionView.register(CommentsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CommentsHeaderView.identifier)
    }
    
    private func setLayout() {
        
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeArea)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(safeArea)
        }
        
        view.addSubview(textFieldView)
        textFieldView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeArea)
        }
    }
    
    private func setDelegate() {
        
        navigationBar.delegate = self
    }
    
    private func bind() {
        
        let input = CommentsViewModel.Input(viewWillAppear: rx.viewWillAppear.asDriver(),
                                            textField: textFieldView.commentsText(),
                                            tapEnterButton: textFieldView.tapEnterButton()
        )
        
        let output = viewModel.transform(input: input)
        
        output.commentsList
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] keyboardHeight in
                let height = keyboardHeight > 0 ? -keyboardHeight + view.safeAreaInsets.bottom : 18
                
                UIView.animate(withDuration: 0.23) {
                    self.textFieldView.snp.updateConstraints {
                        $0.bottom.equalTo(self.safeArea).offset(height)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func layout() -> UICollectionViewLayout {
        
        var config = UICollectionLayoutListConfiguration(appearance: .grouped)
        config.showsSeparators = true
        config.headerMode = .supplementary
        config.headerTopPadding = 0
        config.backgroundColor = .clear
        config.separatorConfiguration.color = .kerdyGray01
        config.separatorConfiguration.bottomSeparatorInsets = .zero
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
}

// MARK: - DataSource

extension CommentsVC {
    
    func setDataSource() {
        
        dataSource = DataSource(configureCell: { [weak self] _, collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ChildCommentsCell.identifier,
                for: indexPath
            ) as? ChildCommentsCell else { return UICollectionViewCell() }
            
            cell.configureCell(with: item)
            self.configure(cell: cell)
            
            return cell
            
        }, configureSupplementaryView: { dataSource, collectionview, _, indexPath in
            
            guard let header = collectionview.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: CommentsHeaderView.identifier,
                for: indexPath
            ) as? CommentsHeaderView else { return UICollectionReusableView() }
            
            let item = dataSource.sectionModels[indexPath.section].header
            let count = dataSource.sectionModels[indexPath.section].items.count
            header.configureHeader(with: item, count: count)
            self.configure(header: header)
            
            return header
        })
    }
}

extension CommentsVC {
    
    func configure(cell: ChildCommentsCell) {
        cell.rx.dot
            .asDriver()
            .drive(with: self) { owner, _ in
                print("cell tap")
            }
            .disposed(by: disposeBag)
    }
    
    func configure(header: CommentsHeaderView) {
        header.rx.dot
            .asDriver()
            .drive(with: self) { owner, _ in
                print("header tap")
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Navi BackButton Delegate

extension CommentsVC: BackButtonActionProtocol {
    
    func backButtonTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }
}
