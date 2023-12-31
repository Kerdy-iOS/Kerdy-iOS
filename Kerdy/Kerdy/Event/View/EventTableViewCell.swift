//
//  EventTableViewCell.swift
//  Temp
//
//  Created by 이동현 on 10/29/23.
//

import UIKit
import SnapKit
import Core
import RxSwift

final class EventTableViewCell: UITableViewCell {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 19)
        label.numberOfLines = 2
        return label
    }()

    private lazy var dDayLabel: UILabel = {
        let label = UILabel()
        label.text = "D-14"
        label.font = .nanumSquare(to: .extraBold, size: 13)
        label.textColor = .kerdyMain
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "무료"
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()

    private lazy var eventMode: UILabel = {
        let label = UILabel()
        label.text = "온라인"
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()

    private lazy var divideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)

    private lazy var tagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        return stackView
    }()

    private lazy var eventImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .kerdyGray01
        imageView.layer.cornerRadius = 15
        return imageView
    }()

    private lazy var tag1: UILabel = {
        let label = UILabel()
        label.backgroundColor = .kerdySub
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()
    
    private lazy var tag2: UILabel = {
        let label = UILabel()
        label.backgroundColor = .kerdySub
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()
    
    private lazy var tag3: UILabel = {
        let label = UILabel()
        label.backgroundColor = .kerdySub
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()
    
    private lazy var tag4: UILabel = {
        let label = UILabel()
        label.backgroundColor = .kerdySub
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()
    
    private let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setTagLayer()
    }

    private func setUpTag(tags: [String]) {
        let tagLabels = [tag1, tag2, tag3, tag4]
        
        for (index, tagLabel) in tagLabels.enumerated() {
            let hiddenState = index >= tags.count
            tagLabel.isHidden = hiddenState
            var title: String?
            title = !hiddenState ? tags[index] : nil
            if index == 3 {
                title = "외 +\(tags.count - 3)"
            }
            if let title = title {
                tagLabel.text = "   \(title)   "
            }
        }
    }
    
    func configure(_ event: Event) {
        titleLabel.text = event.name
        dDayLabel.text = getDdayString(event.startDate)
        priceLabel.text = event.paymentType
        eventMode.text = event.eventMode

        if let thumbnailUrl = event.thumbnailUrl {
            setImage(url: thumbnailUrl)
        }
        setUpTag(tags: event.tags)
    }
    
    private func convertStringToDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString) ?? Date()
    }
    
    private func calculateDaysDifference(_ from: Date) -> Int {
        let todayDate = Date()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: todayDate, to: from)
        return components.day ?? 0
    }
    
    private func getDdayString(_ from: String) -> String {
        let targetDate = convertStringToDate(from)
        let dateDifference = calculateDaysDifference(targetDate)
        
        if dateDifference < 0 {
            return "D\(dateDifference)"
        } else if dateDifference > 0{
            return "D+\(dateDifference)"
        } else {
            return "D-day"
        }
    }
}

// MARK: - layout 설정
extension EventTableViewCell {
    private func setLayout() {
        contentView.addSubview(eventImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dDayLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(divideLine)
        contentView.addSubview(eventMode)
        contentView.addSubview(tagStackView)

        tagStackView.addArrangedSubviews(
            tag1,
            tag2,
            tag3,
            tag4
        )
        
        eventImage.snp.makeConstraints {
            $0.height.equalTo(180)
            $0.width.equalTo(326).priority(250)
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-17)
        }

        dDayLabel.snp.makeConstraints {
            $0.height.equalTo(15)
            $0.width.equalTo(31).priority(500)
            $0.top.equalTo(eventImage.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(17)
        }

        titleLabel.snp.makeConstraints {
            $0.height.equalTo(19).priority(250)
            $0.width.equalTo(326).priority(250)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-17)
            $0.top.equalTo(dDayLabel.snp.bottom).offset(9)
        }

        priceLabel.snp.makeConstraints {
            $0.height.equalTo(14)
            $0.width.equalTo(22).priority(250)
            $0.leading.equalToSuperview().offset(17)
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
        }

        divideLine.snp.makeConstraints {
            $0.height.equalTo(7)
            $0.width.equalTo(1)
            $0.leading.equalTo(priceLabel.snp.trailing).offset(6)
            $0.top.equalTo(priceLabel.snp.top)
        }

        eventMode.snp.makeConstraints {
            $0.height.equalTo(14)
            $0.width.equalTo(33).priority(250)
            $0.leading.equalTo(divideLine.snp.trailing).offset(6)
            $0.top.equalTo(priceLabel.snp.top)
        }

        tagStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(17)
            $0.bottom.equalToSuperview().offset(-5)
            $0.height.equalTo(22)
            $0.width.equalTo(20).priority(250)
        }
    }
    
    func setTagLayer() {
        let tagLabels = [tag1, tag2, tag3, tag4]
        
        tagLabels.forEach {
            if !$0.isHidden {
                $0.roundCorners(
                    topLeft: 8,
                    topRight: 15,
                    bottomLeft: 15,
                    bottomRight: 8,
                    borderColor: .kerdySub
                )
            }
        }
    }
}

// MARK: - 이미지 처리
extension EventTableViewCell {
    private func setImage(url: String) {
        ImageManager.shared.getImage(url: url)
            .subscribe { [weak self] image in
                self?.eventImage.image = image
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
