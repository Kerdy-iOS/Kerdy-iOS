//
//  EventDetailPhotoCVCell.swift
//  Kerdy
//
//  Created by 이동현 on 11/25/23.
//

import UIKit

final class EventDetailPhotoCVCell: EventDetailCVCell {

    private lazy var tableViewHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var titleStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.alignment = .leading
        view.distribution = .equalSpacing
        return view
    }()
    
    private lazy var applyTitle: UILabel = {
        let label = UILabel()
        label.text = "접수기간"
        label.font = .nanumSquare(to: .bold, size: 12)
        return label
    }()
    
    private lazy var dateTitle: UILabel = {
        let label = UILabel()
        label.text = "일시"
        label.font = .nanumSquare(to: .bold, size: 12)
        return label
    }()
    
    private lazy var locationTitle: UILabel = {
        let label = UILabel()
        label.text = "장소"
        label.font = .nanumSquare(to: .bold, size: 12)
        return label
    }()
    
    private lazy var costTitle: UILabel = {
        let label = UILabel()
        label.text = "비용"
        label.font = .nanumSquare(to: .bold, size: 12)
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.alignment = .leading
        view.distribution = .equalSpacing
        return view
    }()
    
    private lazy var applyInfo: UILabel = {
        let label = UILabel()
        label.text = "접수기간"
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()
    
    private lazy var dateInfo: UILabel = {
        let label = UILabel()
        label.text = "일시"
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()
    
    private lazy var locationInfo: UILabel = {
        let label = UILabel()
        label.text = "장소"
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()
    
    private lazy var costInfo: UILabel = {
        let label = UILabel()
        label.text = "비용"
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()
    
    private var imageURLs: [String]?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setHeaderLayout()
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventDetailPhotoTVCell.self, forCellReuseIdentifier: EventDetailPhotoTVCell.identifier)
    }
    
    func configure(with event: EventResponseDTO, cellType: EventDetailCategoryType) {
        configurePostType(cellType)
        applyInfo.text = DateManager
            .shared
            .getApplyDateString(startDate: event.applyStartDate, endDate: event.applyEndDate)
        dateInfo.text = DateManager
            .shared
            .getProgressDateString(startDate: event.startDate, endDate: event.endDate)
        locationInfo.text = event.location
        costInfo.text = event.paymentType
        imageURLs = event.imageUrls
    }
}
// MARK: - layout 설정
extension EventDetailPhotoCVCell {
    private func setLayout() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(400).priority(500)
        }
    }
    
    private func setHeaderLayout() {
        tableViewHeaderView.addSubviews(
            titleStackView,
            infoStackView
        )
        setTitleLayout()
        setInfoLayout()
        
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(17)
            $0.height.equalTo(94)
        }
        
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.top)
            $0.leading.equalTo(titleStackView.snp.trailing).offset(20)
            $0.height.equalTo(94)
        }
    }
    
    private func setTitleLayout() {
        titleStackView.addArrangedSubviews(
            applyTitle,
            dateTitle,
            locationTitle,
            costTitle
        )
    }
    
    private func setInfoLayout() {
        infoStackView.addArrangedSubviews(
            applyInfo,
            dateInfo,
            locationInfo,
            costInfo
        )
    }
}

// MARK: - TableViewDelegate
extension EventDetailPhotoCVCell {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 142
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableViewHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - TableViewDataSource
extension EventDetailPhotoCVCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let imageURLs = imageURLs {
            return imageURLs.count
        } else {
            return 0
        }
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: EventDetailPhotoTVCell.identifier,
                for: indexPath
            ) as? EventDetailPhotoTVCell
        else {
            return UITableViewCell()
        }
        cell.selectionStyle = .blue
        tableView.beginUpdates()
        cell.configure(with: imageURLs![indexPath.row])
        tableView.endUpdates()
        return cell
    }
}

