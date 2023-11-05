//
//  DateSelectBtnView.swift
//  Kerdy
//
//  Created by 이동현 on 11/5/23.
//

import UIKit

final class DateSelectBtnView: UIView {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = nil
        label.font = .nanumSquare(to: .regular, size: 13)
        return label
    }()

    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle(nil, for: .normal)
        return button
    }()

    init() {
        super.init(frame: .zero)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        addSubviews(imageView)
        addSubviews(titleLabel)
        addSubviews(button)

        imageView.snp.makeConstraints {
            $0.width.equalTo(14)
            $0.height.equalTo(14)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(19)
        }

        titleLabel.snp.makeConstraints {
            $0.height.equalTo(17)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
        }

        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setUnselected() {
        imageView.image = UIImage(named: "ic_calendar_off")

        self.roundCorners(topLeft: 15, topRight: 25, bottomLeft: 25, bottomRight: 15)
        let borderLayer = CAShapeLayer()
        guard
            let maskLayer = layer.mask as? CAShapeLayer,
            let path = maskLayer.path
        else { return }
        borderLayer.path = path
        borderLayer.strokeColor = UIColor(named: "kerdy_gray01")?.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 3
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }

    func setSelected() {
        imageView.image = UIImage(named: "ic_calendar_on")

        self.roundCorners(topLeft: 15, topRight: 25, bottomLeft: 25, bottomRight: 15)
        let borderLayer = CAShapeLayer()
        guard
            let maskLayer = layer.mask as? CAShapeLayer,
            let path = maskLayer.path
        else { return }
        borderLayer.path = path
        borderLayer.strokeColor = UIColor(named: "kerdy_main")?.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 3
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
}
