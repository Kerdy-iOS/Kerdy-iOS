//
//  ChatDetailVC.swift
//  Kerdy
//
//  Created by 이동현 on 1/14/24.
//

import UIKit
import SnapKit

final class ChatDetailVC: BaseVC {
    // MARK: - typeAlias
    typealias IncomingCell = IncomingChatCollectionViewCell
    typealias MyCell = MyChatCollectionViewCell
    typealias SectionHeader = ChatDateSupplementaryView
    
    // MARK: - UI Property
    private lazy var navigationBar = NavigationBarView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var textInputView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.kerdyGray01.cgColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    private var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "메시지를 입력하세요."
        textField.font = .nanumSquare(to: .regular, size: 14)
        return textField
    }()
    
    private var inputButton: UIButton = {
        let button = UIButton()
        button.setTitle("입력", for: .normal)
        button.titleLabel?.font = .nanumSquare(to: .bold, size: 14)
        button.setTitleColor(.kerdyMain, for: .normal)
        return button
    }()
    
    // MARK: - property
    private var viewModel = ChatDetailViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        bindViewModel()
    }
    
    // MARK: - Set UI
    private func setUI() {
        navigationBar.delegate = self
        view.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(IncomingCell.self, forCellWithReuseIdentifier: IncomingCell.identifier)
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: MyCell.identifier)
        collectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.identifier
        )
    }
    
    // MARK: - Method
    func configure(roomId: String) {
        viewModel.action(.configre(roomId: roomId))
    }
}

// MARK: - layout 설정
extension ChatDetailVC {
    private func setLayout() {
        view.addSubviews(
            navigationBar,
            collectionView,
            textInputView
        )
        
        textInputView.addSubviews(textField, inputButton)
        
        navigationBar.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(56)
        }
        
        textInputView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(17)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.bottom.equalTo(textInputView.snp.top).offset(-16)
            $0.horizontalEdges.equalToSuperview().inset(17)
        }
        
        inputButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(19)
            $0.width.equalTo(26)
        }
        
        textField.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(19)
            $0.trailing.equalTo(inputButton.snp.leading).inset(16)
        }
        
    }
}

// MARK: - binding
extension ChatDetailVC {
    private func bindViewModel() {
        viewModel
            .chatsObservable
            .subscribe { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - collectionView DataSource
extension ChatDetailVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let chatLogsForDays = viewModel.chatsRelay.value
        return chatLogsForDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let chatLogsForDays = viewModel.chatsRelay.value
        let sectionData = chatLogsForDays[section]
        let messages = sectionData.messages
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let id = viewModel.myId else { return UICollectionViewCell() }
        
        let chatLogsForDays = viewModel.chatsRelay.value
        let sectionData = chatLogsForDays[indexPath.section].messages
        let curData = sectionData[indexPath.row]
        var isContinuous = false
        
        if indexPath.row > 0 {
            let prevData = sectionData[indexPath.row - 1]
            isContinuous = curData.sender.name == prevData.sender.name
        }
        
        if curData.sender.id == id {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyCell.identifier,
                for: indexPath
            ) as? MyCell else {
                return UICollectionViewCell()
            }
            cell.configure(isContinuous: isContinuous, data: curData)
            
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: IncomingCell.identifier,
                for: indexPath
            ) as? IncomingCell else {
                return UICollectionViewCell()
            }
            cell.configure(isContinuous: isContinuous, data: curData)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
        let chatLogsForDays = viewModel.chatsRelay.value
        let sectionData = chatLogsForDays[section]
        let date = sectionData.date
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeader.identifier,
            for: indexPath
        ) as? SectionHeader else {
            return UICollectionReusableView()
        }
        
        headerView.configure(date: date)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 47)
    }
}

// MARK: - collectionView Delegate
extension ChatDetailVC: UICollectionViewDelegate {
    
}

extension ChatDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let chatLogsForDays = viewModel.chatsRelay.value
        let curSectionData = chatLogsForDays[indexPath.section]
            .messages
        let curData = curSectionData[indexPath.row]
        let content = curData.content
        let collectionViewWidth = collectionView.bounds.width
        var isContinuous = false
        
        if indexPath.row > 0 {
            let prevData = curSectionData[indexPath.row - 1]
            isContinuous = curData.sender.name == prevData.sender.name
        }

        let boundingRect = (content as NSString).boundingRect(
            with: CGSize(width: collectionViewWidth - 109, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [
                NSAttributedString.Key.font: UIFont.nanumSquare(to: .regular, size: 12)
            ],
            context: nil
        )

        let textHeight = ceil(boundingRect.height)
        if isContinuous {
            return CGSize(width: collectionViewWidth, height: textHeight + 18)
        } else {
            return CGSize(width: collectionViewWidth, height: textHeight + 34)
        }
    }
}

// MARK: - 뒤로가기 delegate
extension ChatDetailVC: BackButtonActionProtocol {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
