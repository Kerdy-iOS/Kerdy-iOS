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
    static let ID = "eventCVCell"

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    var tableViewItems: [Event]?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        contentView.addSubview(tableView)
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.ID)

        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func configure(with events: Event) {

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
                withIdentifier: EventTableViewCell.ID,
                for: indexPath
            ) as? EventTableViewCell
        else { return UITableViewCell() }
        cell.titleLabel.text = "\(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 158
    }
}
