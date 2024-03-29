//
//  EventDetailCVCell.swift
//  Kerdy
//
//  Created by 이동현 on 1/2/24.
//

import UIKit

class EventDetailCVCell: UICollectionViewCell {
    // MARK: - UI Property
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    // MARK: - Property
    private(set) var postType: EventDetailCategoryType?
    weak var delegate: EventDetailViewController?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setting
    private func setUI() {
        tableView.delegate = self
    }
    
    // MARK: - Method
    func scrollTableViewToTop() {
        tableView.setContentOffset(.zero, animated: true)
    }
    
    func configurePostType(_ cellType: EventDetailCategoryType) {
        self.postType = cellType
    }
}

// MARK: - scrollView delegate
extension EventDetailCVCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY <= 0 {
            delegate?.dataTransfered(data: true)
        }
    }
}

// MARK: - TableView delegate
extension EventDetailCVCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
