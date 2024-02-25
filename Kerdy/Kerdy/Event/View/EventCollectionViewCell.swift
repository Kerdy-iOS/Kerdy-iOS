//
//  EventCollectionViewCell.swift
//  Temp
//
//  Created by 이동현 on 10/29/23.
//

import UIKit
import SnapKit
import Core

protocol EventCollectionViewDelegate: AnyObject {
    func showEvent(event: EventResponseDTO)
}

final class EventCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Property
    typealias DataSource = UITableViewDiffableDataSource<Int, EventResponseDTO>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, EventResponseDTO>
    typealias EventCell = EventTableViewCell
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    // MARK: - Property
    private var tableViewItems: [EventResponseDTO] = []
    private var dataSource: DataSource?
    
    weak var delegate: EventCollectionViewDelegate?
    
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setting, Configure Cell
    private func setUI() {
        tableView.delegate = self
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.identifier)
        configureDataSource()
    }

    func configure(with events: [EventResponseDTO]) {
        tableViewItems = events
        applySnapshot()
    }
}

// MARK: - layout 설정
extension EventCollectionViewCell {
    private func setLayout() {
        contentView.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - CollectionView 설정
extension EventCollectionViewCell {
    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.identifier, for: indexPath) as? EventCell else {
                fatalError("Could not dequeue cell of type EventCell")
            }
            cell.configure(itemIdentifier)
            cell.selectionStyle = .none
            return cell
        })
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(tableViewItems, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - TableView Delegate
extension EventCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.showEvent(event: tableViewItems[indexPath.row])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 318
    }
}
