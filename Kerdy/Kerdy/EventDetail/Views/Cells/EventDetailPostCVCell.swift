//
//  EventDetailCollectionViewCell.swift
//  Kerdy
//
//  Created by 이동현 on 11/24/23.
//

import UIKit
import SnapKit

protocol PostCellDelegate: AnyObject {
    func showPostVC()
}

final class EventDetailPostCVCell: UICollectionViewCell {
//    var delegate: EventCellDelegate?
    private var posts: [PostListModel] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    var tableViewItems: [EventResponseDTO]?

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
        tableView.register(EventDetailPostTVCell.self, forCellReuseIdentifier: EventDetailPostTVCell.identifier)
    }
}

// MARK: - TableViewDelegate
extension EventDetailPostCVCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        delegate?.showDetailVC()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}

// MARK: - TableView Datasource

extension EventDetailPostCVCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewItems?.count ?? 5 // 임시 숫자
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: EventDetailPostTVCell.identifier,
                for: indexPath
            ) as? EventDetailPostTVCell
        else {
            return UITableViewCell()
        }
        
        //임시 데이터
        let boardData = PostListModel(
            title: "제목",
            content: "내용",
            image: nil,
            date: Date(),
            isModified: false,
            commentCnt: 0,
            likeCnt: 0
        )
        cell.configure(with: boardData)
        
        return cell
    }
}

extension EventDetailPostCVCell: ConfigurableCell {
    typealias CellType = [PostListModel]
    
    func configure(with data: [PostListModel]) {
        posts = data
    }
}
