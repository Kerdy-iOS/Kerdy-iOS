//
//  HomeViewController.swift
//  Kerdy
//
//  Created by 이동현 on 2023/10/28.
//

import UIKit
import SnapKit
import Core

final class EventVC: UIViewController {
    private lazy var searchContainerView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var searchView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.kerdyGray01.cgColor
        return view
    }()

    private lazy var searchImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .kerdyGray01
        return imageView
    }()

    private lazy var searchTF: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        return textField
    }()

    private lazy var notificationBtn: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.setImage(UIImage(named: "ic_alert"), for: .normal)
        return button
    }()

    private lazy var categoryContainerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.addArrangedSubview(CategoryView(title: "스크랩", tag: 0))
        view.addArrangedSubview(CategoryView(title: "컨퍼런스", tag: 1))
        view.addArrangedSubview(CategoryView(title: "대회", tag: 2))

        for subview in view.arrangedSubviews {
            if let categoryView = subview as? CategoryView {
                categoryView.button.addTarget(self, action: #selector(categoryBtnTapped), for: .touchUpInside)
            }
        }

        return view
    }()

    private lazy var itemCountContainerView = ItemCountView()

    private lazy var filterBtn: UIView = FilterSettingBtn()

    private lazy var filterContainerView = UIView()

    private lazy var eventCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()

    private lazy var divideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpContainerViews()
        setUpEventCollectionView()
    }

    // MARK: - 오토레이아웃 설정
    private func setUpContainerViews() {
        view.addSubview(searchContainerView)
        view.addSubview(categoryContainerView)
        view.addSubview(filterContainerView)
        view.addSubview(divideLine)

        setUpSearchContainerView()
        setUpCategoryContainerView()
        setUpfilterContainerView()

        searchContainerView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        filterContainerView.snp.makeConstraints { make in
            make.height.equalTo(42).priority(250)
            make.top.equalTo(categoryContainerView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        divideLine.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(filterContainerView.snp.bottom)
        }
    }

    private func setUpsearchView() {
        searchView.addSubview(searchImage)
        searchView.addSubview(searchTF)

        searchImage.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }

        searchTF.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.leading.equalTo(searchImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
        }
    }

    private func setUpSearchContainerView() {
        setUpsearchView()
        searchContainerView.addSubview(searchView)
        searchContainerView.addSubview(notificationBtn)

        searchView.snp.makeConstraints { make in
            make.width.equalTo(242)
            make.height.equalTo(36)
            make.leading.equalToSuperview().offset(17)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }

        notificationBtn.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.trailing.equalToSuperview().offset(-14)
        }
    }

    private func setUpCategoryContainerView() {
        categoryContainerView.snp.makeConstraints { make in
            make.height.equalTo(38)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(searchContainerView.snp.bottom)
        }
    }

    private func setUpfilterContainerView() {
        filterContainerView.addSubview(itemCountContainerView)
        filterContainerView.addSubview(filterBtn)

        itemCountContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(17)
            make.width.equalTo(38)
            make.height.equalTo(14)
        }

        filterBtn.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(14)
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-17)
        }
    }

    private func setUpEventCollectionView() {
        eventCollectionView.delegate = self
        eventCollectionView.dataSource = self
        view.addSubview(eventCollectionView)
        eventCollectionView.register(
            EventCollectionViewCell.self,
            forCellWithReuseIdentifier: EventCollectionViewCell.ID
        )
        eventCollectionView.snp.makeConstraints { make in
            make.top.equalTo(divideLine.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
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
        eventCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateCategoryColor(index: tag)
    }
}

// MARK: - collectionView delegate
extension EventVC: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = eventCollectionView.dequeueReusableCell(
                withReuseIdentifier: EventCollectionViewCell.ID,
                for: indexPath
            ) as? EventCollectionViewCell
        else { return UICollectionViewCell() }
        return cell
    }
}

extension EventVC: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return collectionView.frame.size
    }
}

// MARK: - 캐러셀 메뉴를 위한 scrollView delegate
extension EventVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleIndexPaths = eventCollectionView.indexPathsForVisibleItems
        if let indexPath = visibleIndexPaths.first {
            let row = indexPath.row
            updateCategoryColor(index: row)
        }
    }
}
