//
//  FilterViewController.swift
//  Kerdy
//
//  Created by 이동현 on 11/3/23.
//

import UIKit

final class FilterViewController: UIViewController {
    
    private lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        let navigationItem = UINavigationItem(title: "필터 설정")
        let backButton = UIBarButtonItem(
            image: UIImage(named: "ic_backButton"),
            style: .plain,
            target: self,
            action: #selector(backBtnTapped)
        )
        navigationItem.leftBarButtonItem = backButton
        navigationBar.items = [navigationItem]
        
        return navigationBar
    }()
    private lazy var resetBtnView = ResetBtnView()
    private lazy var progressFilterView = ProgressFilterView()
    private lazy var tagFilterView = TagFilterView()
    private lazy var dateFilterView = DateFilterView()
    private lazy var applyBtn: UIButton = {
        let button = UIButton()
        button.setTitle("적용하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .nanumSquare(to: .bold, size: 16)
        button.layer.cornerRadius = 15
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func setLayout() {
        view.addSubview(navigationBar)
        view.addSubview(resetBtnView)
        view.addSubview(progressFilterView)
        view.addSubview(tagFilterView)
        view.addSubview(dateFilterView)
        view.addSubview(applyBtn)
        
        navigationBar.snp.makeConstraints{
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        resetBtnView.snp.makeConstraints{
            $0.top.equalTo(navigationBar.snp.bottom).offset(6)
            $0.trailing.equalToSuperview().offset(-17)
            $0.height.equalTo(14)
            $0.width.equalTo(74)
        }
        
        progressFilterView.snp.makeConstraints{
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(resetBtnView.snp.bottom).offset(6)
            $0.height.equalTo(91)
        }
        
        tagFilterView.snp.makeConstraints{
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(progressFilterView.snp.bottom)
            $0.height.equalTo(159)
        }
        
        dateFilterView.snp.makeConstraints{
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(tagFilterView.snp.bottom)
            $0.height.equalTo(79)
        }
        
        applyBtn.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-17)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-17)
            $0.height.equalTo(60)
        }
    }
    
    @objc private func backBtnTapped() {
        //Delegate를 통해 이전 view로 필터 전달하는 코드 작성 필요
        dismiss(animated: true)
    }
}
