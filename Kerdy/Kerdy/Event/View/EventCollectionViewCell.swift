//
//  EventCollectionViewCell.swift
//  Temp
//
//  Created by 이동현 on 10/29/23.
//

import UIKit
import SnapKit
import Core

final class EventCollectionViewCell: UICollectionViewCell {

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
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.identifier)
    }

    private func configure(with events: Event) {
        // 추후 tableViewCell 설정 관련
    }
}

extension EventCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewItems?.count ?? 5 // 임시 숫자
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: EventTableViewCell.identifier,
                for: indexPath
            ) as? EventTableViewCell
        else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.titleLabel.text = "\(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 318
    }
}
