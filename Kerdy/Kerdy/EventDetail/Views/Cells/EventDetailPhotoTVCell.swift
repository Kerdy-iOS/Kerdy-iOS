//
//  EventDetailPhotoTableViewCell.swift
//  Kerdy
//
//  Created by 이동현 on 11/24/23.
//

import UIKit
import SnapKit
import RxSwift

final class EventDetailPhotoTVCell: UITableViewCell {
    
    private lazy var infoImageView = UIImageView()
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with url: String) {
        setImage(url: url)
    }
}

// MARK: - layout 설정
extension EventDetailPhotoTVCell {
    private func setLayout(ratio: CGFloat) {
        contentView.addSubview(infoImageView)
        infoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(contentView.snp.width).multipliedBy(ratio).priority(750)
        }
    }
    
    private func setUI() {
        infoImageView.contentMode = .scaleAspectFit
        infoImageView.backgroundColor = .kerdyGray01
    }
}

// MARK: - 이미지 처리
extension EventDetailPhotoTVCell {
    func setImage(url: String) {
        ImageManager.shared.getImage(url: url)
            .subscribe { [weak self] image in
                self?.infoImageView.image = image
                let imageWidth = image.size.width
                let imageHeight = image.size.height
                let ratio = imageHeight / imageWidth
                self?.setLayout(ratio: ratio)
                
                if let tableView = self?.superview as? UITableView {
                    UIView.performWithoutAnimation {
                        tableView.beginUpdates()
                        tableView.endUpdates()
                    }
                }
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
