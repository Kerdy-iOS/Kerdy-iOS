//
//  ProfileTagBtn.swift
//  Kerdy
//
//  Created by 최다경 on 12/27/23.
//

import UIKit

protocol ProfileTagBtnDelegate: AnyObject {
    func deleteBtnTapped(btn: ProfileTagBtn)
}

final class ProfileTagBtn: UIStackView, ProfileTagBtnDelegate {
    
    weak var delegate: ProfileTagBtnDelegate?
    
    var tagId: Int?
    
    var label: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 13)
        return label
    }()
    
    var closeBtn = UIButton()
    
    let img: UIImageView = {
        let img = UIImageView()
        img.image = .icCancel
        return img
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .equalSpacing
        self.spacing = 0
        self.tagId = -1
        self.delegate = self
        closeBtn.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
        setLayout()
    }
    
    override func layoutSubviews() {
        setCorner()
    }
    
    private func setLayout() {
        self.addArrangedSubviews(label, closeBtn)
        closeBtn.addSubview(img)
        
        label.snp.makeConstraints {
            $0.leading.equalTo(self.snp.leading).offset(15)
            $0.trailing.equalTo(self.snp.trailing).offset(-25)
            $0.bottom.equalTo(self.snp.bottom).offset(-10)
        }
        
        closeBtn.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(label.snp.trailing)
        }
        
        img.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(5)
            $0.verticalEdges.equalToSuperview().inset(5)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func deleteBtnTapped(btn: ProfileTagBtn) {
        delegate?.deleteBtnTapped(btn: self)
    }
    
    func setCorner() {
        self.roundCorners(topLeft: 8, topRight: 16, bottomLeft: 16, bottomRight: 8)
        let borderLayer = CAShapeLayer()
        guard let buttonMaskLayer = self.layer.mask as? CAShapeLayer else {
            return
        }
        borderLayer.path = buttonMaskLayer.path
        borderLayer.strokeColor = UIColor.kerdyMain.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 2
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
    
    func setTitle(title: String) {
        label.text = title
    }
    
}
