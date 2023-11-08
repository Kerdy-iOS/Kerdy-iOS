//
//  DateFilterViewController.swift
//  Kerdy
//
//  Created by 이동현 on 11/8/23.
//

import UIKit
import FSCalendar

class DateFilterViewController: UIViewController {
    private lazy var navigationBar: NavigationBarView = {
        let view = NavigationBarView()
        // backButton에 뒤로가기 함수 등록 필요
        return view
    }()

    private lazy var resetBtn = ResetBtn()
    private lazy var periodView = PeriodView()
    private lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.scrollDirection = .vertical
        calendar.appearance.weekdayTextColor = .kerdyBlack
        calendar.appearance.headerTitleColor = .kerdyMain
        calendar.appearance.headerTitleFont = .nanumSquare(to: .bold, size: 20)
        calendar.appearance.titleFont = .nanumSquare(to: .regular, size: 15)
        calendar.appearance.weekdayFont = .nanumSquare(to: .regular, size: 15)
        calendar.allowsSelection = true
        calendar.swipeToChooseGesture.isEnabled = true
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
            $0.top.equalTo(resetBtn.snp.bottom)//.offset(10)
            $0.bottom.equalTo(periodView.snp.top).offset(-10)
        }
    }

    private func setUI() {
        view.backgroundColor = .systemBackground
        navigationBar.configureUI(to: "날짜 선택")
        self.navigationController?.navigationBar.isHidden = true
        
        calendar.delegate = self
        calendar.dataSource = self
    }
}

extension DateFilterViewController: FSCalendarDelegate, FSCalendarDataSource {
    
}
