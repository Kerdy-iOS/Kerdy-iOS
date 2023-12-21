//
//  EventTableViewCell.swift
//  Temp
//
//  Created by 이동현 on 10/29/23.
//

import UIKit
import SnapKit
import Core

final class EventTableViewCell: UITableViewCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 19)
        label.numberOfLines = 2
        return label
    }()

    lazy var dDayLabel: UILabel = {
        let label = UILabel()
        label.text = "D-14"
        label.font = .nanumSquare(to: .extraBold, size: 13)
        label.textColor = .kerdyMain
        return label
    }()

    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "무료"
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()

    lazy var eventMode: UILabel = {
        let label = UILabel()
        label.text = "온라인"
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()

    lazy var divideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)

    lazy var tagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        return stackView
    }()

//    lazy var androidTag: TagView

    lazy var eventImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .kerdyGray01
        imageView.layer.cornerRadius = 15
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpTag() {
        contentView.addSubview(tagStackView)
        for index in 0...2 {
            tagStackView.addArrangedSubview(TagView())
            tagStackView.arrangedSubviews[index].isHidden = true
        }
    }
    
    func configure(_ event: Event) {
        titleLabel.text = event.name
        dDayLabel.text = getDdayString(event.startDate)
        priceLabel.text = event.paymentType
        eventMode.text = event.eventMode
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
            $0.top.equalTo(priceLabel.snp.bottom).offset(21)
            $0.height.equalTo(22)
            $0.width.equalTo(20).priority(250)
        }
    }

}
