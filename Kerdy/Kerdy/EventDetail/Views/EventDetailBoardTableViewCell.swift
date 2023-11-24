//
//  EventDetailBoardTableViewCell.swift
//  Kerdy
//
//  Created by 이동현 on 11/24/23.
//

import UIKit
import SnapKit
import Core

class EventDetailBoardTableViewCell: UITableViewCell {
    typealias DataType = BoardListModel
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 13)
        return label
    }()
    
    private var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 13)
        label.textColor = .kerdyGray03
        label.numberOfLines = 2
        return label
    }()
    
    private var iconStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 6
        view.distribution = .equalSpacing
        return view
    }()
    
    private var image: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    private var divideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 11)
        label.textColor = .kerdyGray02
        return label
    }()
    
    private var commentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 3
        view.distribution = .equalSpacing
        return view
    }()
    
    private var commentIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "icon_comment")
        return view
    }()
    
    private var commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .kerdyMain
        label.font = .nanumSquare(to: .regular, size: 11)
        return label
    }()
    
    private var likeStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 3
        view.distribution = .equalSpacing
        return view
    }()
    
    private var likeIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "icon_like")
        return view
    }()
    
    private var likeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .kerdyRed
        label.font = .nanumSquare(to: .regular, size: 11)
        return label
    }()
}

extension EventDetailBoardTableViewCell{
    private func setLayout() {
        addSubviews(
            titleLabel,
            contentLabel,
            iconStackView,
            divideLine,
            timeLabel,
            image
        )
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(17)
            $0.width.equalTo(210).priority(500)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.width.equalTo(210).priority(500)
            $0.height.equalTo(30)
        }
        
        iconStackView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(13)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.bottom.equalToSuperview().offset(-15)
            $0.width.equalTo(48).priority(250)
            $0.height.equalTo(12)
        }
        
        divideLine.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(16)
            $0.leading.equalTo(iconStackView.snp.trailing).offset(5)
            $0.width.equalTo(1)
            $0.height.equalTo(7)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(14)
            $0.leading.equalTo(divideLine.snp.trailing).offset(5)
            $0.width.equalTo(10).offset(5000)
            $0.height.equalTo(12)
        }
        
        image.snp.makeConstraints {
            $0.size.equalTo(75)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-15)
            $0.trailing.equalToSuperview().offset(-17)
        }
    }
    
    private func setIconLayout() {
        iconStackView.addArrangedSubviews(commentStackView, likeStackView)
        commentStackView.addArrangedSubviews(commentIcon, commentLabel)
        likeStackView.addArrangedSubviews(likeIcon, likeLabel)
        
        commentStackView.snp.makeConstraints {
            $0.width.equalTo(21).priority(500)
            $0.height.equalTo(12)
        }
        
        commentIcon.snp.makeConstraints {
            $0.size.equalTo(11)
        }
        
        commentLabel.snp.makeConstraints {
            $0.width.equalTo(7)
        }
        
        likeStackView.snp.makeConstraints {
            $0.width.equalTo(21).priority(500)
            $0.height.equalTo(12)
        }
        
        likeIcon.snp.makeConstraints {
            $0.size.equalTo(11)
        }
        
        likeLabel.snp.makeConstraints {
            $0.width.equalTo(7)
        }
    }
}


extension EventDetailBoardTableViewCell: ConfigurableCell {
    typealias CellType = BoardListModel
    
    func configure(with data: BoardListModel) {
        titleLabel.text = data.title
        contentLabel.text = data.content
        image.image = data.image
        commentLabel.text = String(data.commentCnt)
        timeLabel.text = "임시 날짜"
        
        if let likeCnt = data.likeCnt {
            likeLabel.text = String(likeCnt)
        } else {
            likeStackView.isHidden = true
        }
    }
}
