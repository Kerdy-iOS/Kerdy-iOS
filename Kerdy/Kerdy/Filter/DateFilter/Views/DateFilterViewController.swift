//
//  DateFilterViewController.swift
//  Kerdy
//
//  Created by 이동현 on 11/8/23.
//

import UIKit
import FSCalendar

final class DateFilterViewController: UIViewController {

    private lazy var navigationBar = NavigationBarView()
    private lazy var resetBtn = ResetBtn()
    private lazy var periodView = PeriodView()
    private lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.scrollDirection = .horizontal
        calendar.appearance.weekdayTextColor = .kerdyBlack
        calendar.appearance.headerTitleColor = .kerdyMain
        calendar.appearance.headerTitleFont = .nanumSquare(to: .bold, size: 20)
        calendar.appearance.titleFont = .nanumSquare(to: .regular, size: 15)
        calendar.appearance.weekdayFont = .nanumSquare(to: .regular, size: 15)
        calendar.appearance.todayColor = .kerdyGray01
        calendar.appearance.selectionColor = .kerdySub
        calendar.appearance.titleSelectionColor = .kerdyBlack
        calendar.allowsMultipleSelection = true
        return calendar
    }()
    private lazy var applyBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .kerdyMain
        button.setTitle("적용하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .nanumSquare(to: .bold, size: 16)
        button.layer.cornerRadius = 15
        return button
    }()
    
    weak var delegate: DataTransferDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setUI()
    }
    
    private func setLayout() {
        view.addSubviews(
            navigationBar,
            resetBtn,
            periodView,
            calendar,
            applyBtn
        )

        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }

        resetBtn.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.trailing.equalToSuperview().offset(-17)
            $0.height.equalTo(14)
            $0.width.equalTo(74)
        }

        applyBtn.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-17)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-17)
            $0.height.equalTo(60)
        }

        periodView.snp.makeConstraints {
            $0.bottom.equalTo(applyBtn.snp.top).offset(-15)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-17)
            $0.height.equalTo(40)
        }

        calendar.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-17)
            $0.top.equalTo(resetBtn.snp.bottom)
            $0.bottom.equalTo(periodView.snp.top).offset(-10)
        }
    }

    private func setUI() {
        view.backgroundColor = .systemBackground
        navigationBar.configureUI(to: "날짜 선택")
        navigationBar.delegate = self
        self.navigationController?.navigationBar.isHidden = true

        calendar.delegate = self
        calendar.dataSource = self
        resetBtn.addTarget(self, action: #selector(resetBtnTapped), for: .touchUpInside)
        applyBtn.addTarget(self, action: #selector(applyBtnTapped), for: .touchUpInside)
    }

    @objc private func resetBtnTapped() {
        for selectedDate in calendar.selectedDates {
            calendar.deselect(selectedDate)
            periodView.reset()
        }
    }
    
    @objc private func applyBtnTapped() {
        var selectedDates: [String] = []
        if
            let startDate = periodView.startLabel.text,
            startDate != "시작일 선택"
        {
            selectedDates.append(startDate)
        }
        
        if
            let endDate = periodView.endLabel.text,
            endDate != "종료일 선택"
        {
            selectedDates.append(endDate)
        }
        delegate?.dataTransfered(data: selectedDates)
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateSelectedDateLabel(dates: [Date]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        switch dates.count {
        case 0:
            periodView.setStartDate(date: "시작일 선택")
            periodView.setStartDate(date: "종료일 선택")
        case 1:
            let startDateString = dateFormatter.string(from: dates[0])
            periodView.setStartDate(date: startDateString)
            periodView.setEndDate(date: "종료일 선택")
        default:
            let startDateString = dateFormatter.string(from: dates[0])
            let endDateString = dateFormatter.string(from: dates[1])
            periodView.setStartDate(date: startDateString)
            periodView.setEndDate(date: endDateString)
        }
    }
}

extension DateFilterViewController: BackButtonActionProtocol {
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DateFilterViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendar.selectedDates.count > 2 {
            for _ in 0 ..< calendar.selectedDates.count {
                if let deselectDate = calendar.selectedDates.first {
                    calendar.deselect(deselectDate)
                }
            }
            calendar.select(date)
        }
        
        if calendar.selectedDates.count == 2 {
            let currentCalendar = Calendar.current
            let startDate = calendar.selectedDates[0]
            let endDate = calendar.selectedDates[1]
            
            if startDate > endDate {
                for _ in 0 ..< calendar.selectedDates.count {
                    calendar.deselect(calendar.selectedDates[0])
                }
                calendar.select(endDate)
            } else {
                var dateToAdd = startDate
                while dateToAdd < endDate {
                    if let nextDate = currentCalendar.date(byAdding: .day, value: 1, to: dateToAdd) {
                        dateToAdd = nextDate
                        calendar.select(dateToAdd)
                    }
                }
            }
        }
        updateSelectedDateLabel(dates: calendar.selectedDates)
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        while calendar.selectedDates.count > 1 {
            calendar.deselect(calendar.selectedDates[1])
        }
        
        updateSelectedDateLabel(dates: calendar.selectedDates)
    }
}
