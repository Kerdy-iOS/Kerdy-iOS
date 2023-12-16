//
//  EventDetailBottomView.swift
//  Kerdy
//
//  Created by 이동현 on 11/24/23.
//

import UIKit
import SnapKit

final class EventDetailBottomView: UIView {   
    private lazy var moveWebsiteBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .kerdyMain
        button.setTitle("웹사이트로 이동", for: .normal)
        button.titleLabel?.font = .nanumSquare(to: .bold, size: 13)
        button.layer.cornerRadius = 15
        return button
    }()
    private lazy var bookmarkBtn = UIButton()
    
    private lazy var bookemarkImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "ic_bookmark_off")
        return image
    }()
    
    private lazy var bookmarkLabel: UILabel = {
        let label = UILabel()
        label.text = "스크랩"
        label.font = .nanumSquare(to: .regular, size: 10)
        label.textColor = .kerdyGray02
        return label
    }()
    
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
            bookemarkImage,
            bookmarkLabel,
            bookmarkBtn
        )
        bookemarkImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-26)
            $0.width.equalTo(20)
            $0.height.equalTo(25)
        }
        
        bookmarkLabel.snp.makeConstraints {
            $0.top.equalTo(bookemarkImage.snp.bottom).offset(6)
            $0.bottom.equalToSuperview().offset(-15)
            $0.centerX.equalTo(bookemarkImage.snp.centerX)
            $0.height.equalTo(11)
        }
        
        bookmarkBtn.snp.makeConstraints {
            $0.top.equalTo(bookemarkImage.snp.top)
            $0.horizontalEdges.equalTo(bookmarkLabel.snp.horizontalEdges)
            $0.bottom.equalTo(bookmarkLabel.snp.bottom)
        }
        
        moveWebsiteBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalTo(bookmarkBtn.snp.leading).offset(-17)
        }
    }
}

