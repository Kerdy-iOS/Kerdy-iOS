//
//  EventDetailTagCell.swift
//  Kerdy
//
//  Created by 이동현 on 1/1/24.
//

import UIKit

final class EventDetailTagCell: UICollectionViewCell {
    private lazy var tagBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .kerdySub
        view.layer.masksToBounds = true
        return view
    }()
    
    private(set) lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayer()
    }
    
    func configure(tag: String) {
        tagLabel.text = tag
    }
}

// MARK: - layout 설정
extension EventDetailTagCell {
    private func setLayout() {
        addSubview(tagBackground)
        tagBackground.addSubview(tagLabel)
        
        tagBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tagLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.verticalEdges.equalToSuperview().inset(3)
        }
    }

    func setLayer() {
        self.roundCorners(
            topLeft: 8,
            topRight: 15,
            bottomLeft: 15,
            bottomRight: 8,
            borderColor: .kerdySub
        )
    }
}

