//
//  ActivityBtn.swift
//  Kerdy
//
//  Created by 최다경 on 1/6/24.
//

import UIKit

protocol ActivityBtnDelegate: AnyObject {
    func deleteBtnTapped(btn: ActivityBtn)
}

final class ActivityBtn: UIStackView, ActivityBtnDelegate {
    
    weak var delegate: ActivityBtnDelegate?
    
    var tagId: Int = -1
    
    var label: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .regular, size: 13)
        return label
    }()
    
    let dotImg: UIImageView = {
        let img = UIImageView()
        img.image = .icDot
        return img
    }()
    
    var closeBtn = UIButton()
    
    let img: UIImageView = {
        let img = UIImageView()
        img.image = .icCancel
        return img
    }()
    
    let baseView: UIView = {
        let view = UIView()
        return view
    }()
    
    let emptyView: UIView = {
        let view = UIView()
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        self.axis = .horizontal
        self.spacing = 0
        self.delegate = self
        closeBtn.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
        setLayout()
    }
    
    private func setLayout() {
        
        baseView.addSubview(dotImg)
        
        baseView.snp.makeConstraints {
            $0.width.equalTo(26)
            $0.height.equalTo(26)
        }
        
        dotImg.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        closeBtn.snp.makeConstraints {
            $0.width.equalTo(26)
            $0.height.equalTo(26)
        }
        
        self.addArrangedSubviews(
            baseView,
            label,
            closeBtn,
            emptyView
        )
        closeBtn.addSubview(img)
             
        img.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func deleteBtnTapped(btn: ActivityBtn) {
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
        borderLayer.lineWidth = 3
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
    
    func setTitle(title: String) {
        label.text = title
    }
    
}
