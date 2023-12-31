//
//  EventDetailPhotoTableViewCell.swift
//  Kerdy
//
//  Created by 이동현 on 11/24/23.
//

import UIKit
import SnapKit

final class EventDetailPhotoTVCell: UITableViewCell {
    
    private lazy var image = UIImageView()
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EventDetailPhotoTVCell {
    private func setLayout() {
        addSubview(image)
        image.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setUI() {
        image.contentMode = .scaleAspectFit
    }
}

extension EventDetailPhotoTVCell: ConfigurableCell {
    typealias CellType = UIImage?
    
    func configure(with data: UIImage?) {
        image.image = data
    }
}
