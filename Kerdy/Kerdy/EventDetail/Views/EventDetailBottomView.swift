//
//  EventDetailBottomView.swift
//  Kerdy
//
//  Created by 이동현 on 11/24/23.
//

import UIKit
import SnapKit

final class EventDetailBottomView: UIView {   
    private var moveWebsiteBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .kerdyMain
        button.setTitle("웹사이트로 이동", for: .normal)
        button.titleLabel?.font = .nanumSquare(to: .bold, size: 13)
        button.layer.cornerRadius = 15
        return button
    }()
    private var bookMarkBtn = UIButton() //구현 예정
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubviews(
            moveWebsiteBtn,
            bookMarkBtn
        )
        bookMarkBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.bottom.equalToSuperview().offset(-15)
            $0.trailing.equalToSuperview().offset(-17)
            $0.width.equalTo(38)
            $0.height.equalTo(42)
        }
        
        moveWebsiteBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalTo(bookMarkBtn.snp.leading).offset(-17)
        }
    }
}

