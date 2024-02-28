//
//  EventDetailCollectionViewCell.swift
//  Kerdy
//
//  Created by 이동현 on 11/24/23.
//

import UIKit
import SnapKit

final class EventDetailPostCVCell: EventDetailCVCell {
    // MARK: - UI Property
    private lazy var informationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .nanumSquare(to: .regular, size: 13)
        label.textColor = .kerdyGray03
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Property
    private var feeds: [FeedResponseDTO] = []
    private var recruitmemts: [RecruitmentResponseDTO] = []
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setting
    private func setUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventDetailFeedTVCell.self, forCellReuseIdentifier: EventDetailFeedTVCell.identifier)
        tableView.register(EventDetailRecruitTVCell.self, forCellReuseIdentifier: EventDetailRecruitTVCell.identifier)
        
        guard let postType = postType else { return }
        if postType == .feed {
            setHidden(isDataEmpty: feeds.isEmpty)
        } else {
            setHidden(isDataEmpty: recruitmemts.isEmpty)
        }
    }
    
    // MARK: - Cell configuration
    func configure<T>(data: [T], cellType: EventDetailCategoryType) {
        configurePostType(cellType)
        if cellType == .feed {
            guard let data = data as? [FeedResponseDTO] else { return }
            feeds = data
            recruitmemts = []
            informationLabel.text = "작성된 피드가 없습니다.\n새 글을 작성해보세요!"
            setHidden(isDataEmpty: feeds.isEmpty)
        } else {
            guard let data = data as? [RecruitmentResponseDTO] else { return }
            feeds = []
            recruitmemts = data
            informationLabel.text = "작성된 함께하기가 없습니다.\n새 글을 작성해보세요!"
            setHidden(isDataEmpty: recruitmemts.isEmpty)
        }
        tableView.reloadData()
    }
}

// MARK: - layout 설정
extension EventDetailPostCVCell {
    private func setLayout() {
        contentView.addSubviews(tableView, informationLabel)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        informationLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setHidden(isDataEmpty: Bool) {
        informationLabel.isHidden = !isDataEmpty
        tableView.isHidden = isDataEmpty
    }
}

// MARK: - TableViewDelegate
extension EventDetailPostCVCell {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if postType == .feed {
            let id = feeds[indexPath.row].id
            delegate?.showFeed(feedId: id)
        } else {
            let id = recruitmemts[indexPath.row].postId
            delegate?.showRecruitMent(postId: id)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - TableView Datasource
extension EventDetailPostCVCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let postType = postType else { return 0 }
        
        if postType == .feed {
            return feeds.count
        } else {
            return recruitmemts.count
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let postType = postType else { return UITableViewCell() }
        
        if postType == .feed {
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: EventDetailFeedTVCell.identifier,
                    for: indexPath
                ) as? EventDetailFeedTVCell
            else {
                return UITableViewCell()
            }
            cell.configure(with: feeds[indexPath.row])
            return cell
        } else {
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: EventDetailRecruitTVCell.identifier,
                    for: indexPath
                ) as? EventDetailRecruitTVCell
            else {
                return UITableViewCell()
            }
            cell.configure(with: recruitmemts[indexPath.row])
            return cell
        }
    }
}
