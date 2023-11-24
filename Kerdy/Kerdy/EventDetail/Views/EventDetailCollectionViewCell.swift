//
//  EventDetailCollectionViewCell.swift
//  Kerdy
//
//  Created by 이동현 on 11/24/23.
//

import UIKit
import SnapKit
import Core

protocol ConfigurableCell {
    associatedtype CellType
    func configure(with data: CellType)
}

protocol PostCellDelegate {
    func showPostVC()
}

enum EventDetailCellType {
    case photo
    case board

    var identifier: String {
        switch self {
        case .photo:
            return EventDetailPhotoTableViewCell.identifier
        case .board:
            return EventDetailBoardTableViewCell.identifier
        }
    }
}

final class EventDetailCollectionViewCell: UICollectionViewCell {
    var delegate: EventCellDelegate?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    var tableViewItems: [Event]?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        contentView.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventDetailPhotoTableViewCell.self, forCellReuseIdentifier: EventDetailPhotoTableViewCell.identifier)
        tableView.register(EventDetailBoardTableViewCell.self, forCellReuseIdentifier: EventDetailBoardTableViewCell.identifier)
    }

    private func configure(with events: Event) {
        // 추후 tableViewCell 설정 관련
    }
}

extension EventDetailCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    private func configure<T: ConfigurableCell>(cell: T, with data: T.CellType) {
        cell.configure(with: data)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewItems?.count ?? 5 // 임시 숫자
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cellType: EventDetailCellType = (indexPath.row == 0) ? .photo : .board

        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: cellType.identifier,
                for: indexPath
            ) as? any UITableViewCell & ConfigurableCell
        else {
            return UITableViewCell()
        }

        switch cellType {
        case .photo:
            if let photoCell = cell as? EventDetailPhotoTableViewCell {
                let photoData = UIImage(systemName: "pencil") // 임시 이미지
                photoCell.configure(with: photoData)
            }
        case .board:
            if let boardCell = cell as? EventDetailBoardTableViewCell {
               let boardData = BoardListModel(
                title: "제목",
                content: "내용",
                image: nil,
                date: Date(),
                isModified: false,
                commentCnt: 0,
                likeCnt: 0
                )
                boardCell.configure(with: boardData)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType: EventDetailCellType = (indexPath.row == 0) ? .photo : .board
        if cellType == .board {
            delegate?.showDetailVC()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType: EventDetailCellType = (indexPath.row == 0) ? .photo : .board
        switch cellType {
        case .photo:
            return 511
        case .board:
            return 105
        }
    }
}

