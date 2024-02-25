//
//  SettingWrittenVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/10/23.
//

import UIKit

import RxSwift

final class SettingCommentsVC: BaseVC {
    
    // MARK: - Property
    
    private let viewModel: SettingCommenetViewModel
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    private lazy var commentDataSource = SettingWrittenDataSource<Comment>(collectionView: collectionView, type: .comment)
    
    // MARK: - UI Components
    
    private let navigationBar: NavigationBarView = {
        let view = NavigationBarView()
        view.configureUI(to: Strings.comments)
        return view
    }()
    
    // MARK: - Life Cycle
    
    init(viewModel: SettingCommenetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setUI()
        setBindings()
    }
}

// MARK: - Setting

extension SettingCommentsVC {
    
    private func setLayout() {
        
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(safeArea)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setUI() {
        
        navigationBar.delegate = self
        collectionView.dataSource = commentDataSource.dataSource
    }
    
    private func setBindings() {
        
        let input = SettingCommenetViewModel.Input(viewWillAppear: rx.viewWillAppear.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.commentsList
            .drive(with: self, onNext: { owner, comments in
                owner.commentDataSource.updateData(with: comments)
            })
            .disposed(by: disposeBag)
        
        commentDataSource.itemSelectedSubject
            .bind(with: self) { owner, commentID in
                
                let commentsVC = CommentsVC(viewModel: CommentsViewModel(commentID: commentID))
                owner.navigationController?.pushViewController(commentsVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Navi BackButton Delegate

extension SettingCommentsVC: BackButtonActionProtocol {
    
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
