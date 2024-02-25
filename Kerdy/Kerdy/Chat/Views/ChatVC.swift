//
//  ChatVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 10/31/23.
//

import UIKit
import SnapKit
import Core

final class ChatVC: BaseVC {
    // MARK: - UI Property
    private lazy var navigationView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "메시지"
        label.font = .nanumSquare(to: .bold, size: 14)
        return label
    }()
    
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setImage(.icMore, for: .normal)
        button.setTitle(nil, for: .normal)
        return button
    }()
    
    private lazy var divideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Property
    private let viewModel = ChatViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.action(.refresh)
    }
    // MARK: - set UI
    private func setUI() {
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChatListCollectionViewCell.self, forCellWithReuseIdentifier: ChatListCollectionViewCell.identifier)
    }
}

// MARK: - layout 설정
extension ChatVC {
    private func setLayout() {
        view.addSubviews(navigationView, collectionView)
        navigationView.addSubviews(
            titleLabel,
            settingButton,
            divideLine
        )
        
        navigationView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(56)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        settingButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
            $0.size.equalTo(24)
        }
        
        divideLine.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(17)
            $0.top.equalTo(navigationView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: - binding
extension ChatVC {
    func bindViewModel() {
        viewModel
            .roomsObservable
            .subscribe { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - collectionView DataSource
extension ChatVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.roomsRelay.value.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatListCollectionViewCell.identifier, for: indexPath) as? ChatListCollectionViewCell else { return UICollectionViewCell() }
        
        let rooms = viewModel.roomsRelay.value
        cell.configure(room: rooms[indexPath.row])
        return cell
    }
    
}

// MARK: - collectionView Delegate
extension ChatVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = .kerdyGray01
            let rooms = viewModel.roomsRelay.value
            let roomId = rooms[indexPath.row].roomId
            let nextVC = ChatDetailVC()
            nextVC.configure(roomId: roomId)
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = .clear
        }
    }
}

// MARK: - collectionView DelegateFlowLayout
extension ChatVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = 62
        return CGSize(width: width, height: height)
    }
}
