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
                categoryView.button.addTarget(self, action: #selector(categoryBtnTapped), for: .touchUpInside)
            }
        }

        return view
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    private var bottomView = EventDetailBottomView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setUI()
    }
    
    private func updateCategoryColor(index: Int) {
        for categoryIndex in 0...2 {
            guard
                let categoryView = categoryContainerView.arrangedSubviews[categoryIndex] as? CategoryView
            else { return }

            if categoryIndex == index {
                categoryView.setSelected()
            } else {
                categoryView.setUnselected()
            }
        }
    }

    @objc func categoryBtnTapped(_ sender: UIButton) {
        let tag = sender.tag
        let indexPath = IndexPath(item: tag, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateCategoryColor(index: tag)
    }
}
// MARK: - layout 설정
extension EventDetailViewController {
    private func setLayout() {
        view.addSubviews(
            navigationBar,
            scrollView,
            bottomView
        )
        scrollView.addSubview(scrollContentView)
        setScrollContentViewLayout()
        
        navigationBar.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(56)
        }
        
        bottomView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(74)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.bottom.equalTo(bottomView.snp.top)
            $0.horizontalEdges.equalToSuperview()
        }
        
        scrollContentView.snp.makeConstraints {
            let frameLayout = scrollView.frameLayoutGuide.snp
            let contentLayout = scrollView.contentLayoutGuide.snp
            $0.edges.equalTo(contentLayout.edges)
            $0.width.equalTo(frameLayout.width)
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
        
        categoryContainerView.snp.makeConstraints {
            $0.top.equalTo(summaryInfoView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(38)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(categoryContainerView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(409).priority(500)
        }
        
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        scrollView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EventDetailCollectionViewCell.self, forCellWithReuseIdentifier: EventDetailCollectionViewCell.identifier)
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
        let cellType: EventDetailCellType = (indexPath.row == 0) ? .photo : .board
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EventDetailCollectionViewCell.identifier,
                for: indexPath
            ) as? EventDetailCollectionViewCell
        else { return UICollectionViewCell() }
        cell.setCelltype(type: cellType)
        if indexPath.row == 0 { cell.tableView.isScrollEnabled = false}
        return cell
    }
}

extension EventDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return collectionView.frame.size
    }
}

// MARK: - 캐러셀 메뉴를 위한 scrollView delegate
extension EventDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        if let indexPath = visibleIndexPaths.first {
            let row = indexPath.row
            updateCategoryColor(index: row)
        }
    }
}
