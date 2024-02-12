//
//  FilterCollectionViewCell.swift
//  Kerdy
//
//  Created by 이동현 on 12/18/23.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Property
    private lazy var tagBackground: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        return view
    }()
    
    private(set) lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 13)
        return label
    }()
    
    private var deleteBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.cancelIcon, for: .normal)
        return button
    }()
    
    // MARK: - Propertu
    private(set) var type: FilterType?
    
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayer()
    }
    
    // MARK: - <##>Configure Cell
    func configure(tag: String, type: FilterType) {
        tagLabel.text = tag
        self.type = type
    }
}

// MARK: - layout 설정
extension FilterCollectionViewCell {
    private func setLayout() {
        addSubview(tagBackground)
        tagBackground.addSubviews(tagLabel, deleteBtn)
        
        tagBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tagLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.verticalEdges.equalToSuperview().inset(3)
        }
        
        deleteBtn.snp.makeConstraints {
            $0.size.equalTo(10)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(tagLabel.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().offset(-12)
        }
    }

    func setLayer() {
        self.roundCorners(
            topLeft: 8,
            topRight: 15,
            bottomLeft: 15,
            bottomRight: 8
        )
        let borderLayer = CAShapeLayer()
        guard
            let maskLayer = layer.mask as? CAShapeLayer,
            let path = maskLayer.path
        else { return }
        borderLayer.path = path
        borderLayer.strokeColor = UIColor.kerdyMain.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 3
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
}
