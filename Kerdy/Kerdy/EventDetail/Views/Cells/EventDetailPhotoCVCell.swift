//
//  EventDetailPhotoCVCell.swift
//  Kerdy
//
//  Created by 이동현 on 11/25/23.
//

import UIKit

final class EventDetailPhotoCVCell: UICollectionViewCell {
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var scrollContentView = UIView()
    
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
    
    private func setUI() {
        scrollView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventDetailPhotoTVCell.self, forCellReuseIdentifier: EventDetailPhotoTVCell.identifier)
    }
}
// MARK: - layout 설정
extension EventDetailPhotoCVCell {
    private func setLayout() {
        addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubviews(
            titleStackView,
            infoStackView,
            tableView
        )
        setTitleLayout()
        setInfoLayout()
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollContentView.snp.makeConstraints {
            let contentLayout = scrollView.contentLayoutGuide.snp
            let frameLayout = scrollView.frameLayoutGuide.snp
            $0.edges.equalTo(contentLayout.edges)
            $0.width.equalTo(frameLayout.width)
            $0.height.equalTo(1000).priority(250)
        }
        
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
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(24)
            $0.horizontalEdges.bottom.equalToSuperview()
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
extension EventDetailPhotoCVCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 511
    }
}

// MARK: - TableViewDataSource
extension EventDetailPhotoCVCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewItems?.count ?? 5 // 임시 숫자
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
        let data = UIImage(systemName: "pencil") // 임시 이미지
        cell.configure(with: data)
        return cell
    }
}

extension EventDetailPhotoCVCell: ConfigurableCell {
    typealias CellType = EventDetailModel
    
    func configure(with data: EventDetailModel) {
        applyInfo.text = data.applyInfo
        dateInfo.text = data.dateInfo
        locationInfo.text = data.locationInfo
        costInfo.text = data.costInfo
        //이미지 설정
        //이미지 갯수에 따라 tv 높이 바뀌도록 수정 예정
        tableView.snp.makeConstraints {
            $0.height.equalTo(511 * 5)
        }
    }
}
