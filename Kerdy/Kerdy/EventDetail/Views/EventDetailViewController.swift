//
//  EventDetailViewController.swift
//  Kerdy
//
//  Created by 이동현 on 11/11/23.
//

import UIKit

class EventDetailViewController: UIViewController {
    private var navigationBar = NavigationBarView()
    private var scrollView = UIScrollView()
    private var scrollContentView = UIView()
    private var titleImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .kerdyGray01
        image.layer.cornerRadius = 15
        return image
    }()
    private var summaryInfoView = UIView() // 구현 예정
    private lazy var categoryContainerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.addArrangedSubview(CategoryView(title: "상세정보", tag: 0))
        view.addArrangedSubview(CategoryView(title: "게시판", tag: 1))
        view.addArrangedSubview(CategoryView(title: "함께해요", tag: 2))

        for subview in view.arrangedSubviews {
            if let categoryView = subview as? CategoryView {
//                categoryView.button.addTarget(self, action: #selector(categoryBtnTapped), for: .touchUpInside)
            }
        }

        return view
    }()
    private var collectionView = UICollectionView()
    private var bottomTabStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 17
        return stackView
    }()
    private var moveWebsiteBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .kerdyMain
        button.setTitle("웹사이트로 이동", for: .normal)
        button.titleLabel?.font = .nanumSquare(to: .bold, size: 13)
        button.layer.cornerRadius = 15
        return button
    }()
    private var bookMarkBtn = UIButton() //구현 예정
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setUI()
    }
 // MARK: - layout 설정
    private func setLayout() {
        view.addSubviews(
            navigationBar,
            scrollView,
            bottomTabStackView
        )
        scrollView.addSubview(scrollContentView)
        setScrollContentViewLayout()
        setBottomTabLayout()
        
        navigationBar.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        bottomTabStackView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(74)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.bottom.equalTo(scrollView.snp.top)
            $0.horizontalEdges.equalToSuperview()
        }
        
        scrollContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.bounds.width)
            $0.height.equalTo(100).priority(250)
        }
    }
    
    private func setScrollContentViewLayout() {
        scrollContentView.addSubviews(
            titleImage,
            summaryInfoView,
            categoryContainerView,
            collectionView
        )
        
        titleImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-17)
            $0.height.equalTo(180)
        }
        
        summaryInfoView.snp.makeConstraints {
            $0.top.equalTo(titleImage.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-17)
            $0.height.equalTo(110)
        }
    }
    
    private func setBottomTabLayout() {
        bottomTabStackView.addArrangedSubviews(
            moveWebsiteBtn,
            bookMarkBtn
        )
        
        moveWebsiteBtn.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalTo(200).priority(250)
            $0.centerY.equalToSuperview()
        }
        
        bookMarkBtn.snp.makeConstraints {
            $0.height.equalTo(42)
            $0.width.equalTo(28)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setUI() {
        scrollView.showsVerticalScrollIndicator = false
    }
}
// MARK: - collectionView delegate
extension EventDetailViewController: UICollectionViewDelegate {
    
}
// MARK: - collectionView dataSource
extension EventDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell() //구현 예정
    }
}

