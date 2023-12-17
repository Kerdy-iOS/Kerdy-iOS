//
//  EventDetailBoardTableViewCell.swift
//  Kerdy
//
//  Created by 이동현 on 11/24/23.
//

import UIKit
import SnapKit
import Core

final class EventDetailPostTVCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 13)
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 13)
        label.textColor = .kerdyGray03
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var iconStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 6
        view.distribution = .equalSpacing
        return view
    }()
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var divideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 11)
        label.textColor = .kerdyGray02
        return label
    }()
    
    private lazy var commentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 3
        view.distribution = .equalSpacing
        view.alignment = .leading
        return view
    }()
    
    private lazy var commentIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ic_comment")
        return view
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .kerdyMain
        label.font = .nanumSquare(to: .regular, size: 11)
        return label
    }()
    
    private lazy var likeStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 3
        view.distribution = .equalSpacing
        view.alignment = .leading
        return view
    }()
    
    private lazy var likeIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ic_like")
        return view
    }()
    
    private lazy var likeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .kerdyRed
        label.font = .nanumSquare(to: .regular, size: 11)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EventDetailPostTVCell {
    private func setLayout() {
        addSubviews(
            titleLabel,
            contentLabel,
            iconStackView,
            divideLine,
            timeLabel,
            image
        )
        setIconLayout()
        
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


extension EventDetailPostTVCell: ConfigurableCell {
    typealias CellType = PostListModel
    
    func configure(with data: PostListModel) {
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
