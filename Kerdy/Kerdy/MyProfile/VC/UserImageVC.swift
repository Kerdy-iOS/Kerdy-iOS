//
//  UserImageViewController.swift
//  Kerdy
//
//  Created by 최다경 on 12/22/23.
//

import UIKit

final class UserImageVC: UIViewController {
    
    private lazy var userImg: UIImageView = {
        let imgView = UIImageView()
        imgView.image = .imgUser
        return imgView
    }()
    
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.icCancel, for: .normal)
        btn.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    private func setLayout() {
        view.addSubviews(
            userImg,
            closeBtn
        )
        
        userImg.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(300)
            $0.center.equalToSuperview()
        }
        
        closeBtn.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(24)
            $0.top.equalToSuperview().offset(55)
            $0.leading.equalToSuperview().offset(17)
        }
    }
    
    private func setUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    @objc func closeBtnTapped() {
        dismiss(animated: false)
    }

}
