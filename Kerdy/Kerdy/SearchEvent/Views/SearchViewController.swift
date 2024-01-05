//
//  SearchEventViewController.swift
//  Kerdy
//
//  Created by 이동현 on 12/21/23.
//

import UIKit
import SnapKit
import Core
import RxSwift
import RxCocoa

class SearchEventViewController: BaseVC {
    private lazy var navigationBar: NavigationBarView  = {
        let view = NavigationBarView()
        view.configureUI(to: "검색하기")
        view.delegate = self
        return view
    }()
    
    private lazy var searchView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.kerdyMain.cgColor
        return view
    }()

    private lazy var searchImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .kerdyMain
        return imageView
    }()
    
    private lazy var searchTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "검색어를 입력하세요."
        tf.font = .nanumSquare(to: .bold, size: 14)
        tf.delegate = self
        return tf
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setImage(.icClear, for: .normal)
        button.setTitle(nil, for: .normal)
        return button
    }()

    private lazy var descriptionView = UIView()
    private lazy var itemCountContainerView = ItemCountView()
    private lazy var recentDiscriptionView = RecentDescriptionView()
    
    private lazy var noResultImage: UIImageView = {
        let image = UIImageView()
        image.image = .noResult
        return image
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.identifier)
        tableView.register(RecentKeywordTableViewCell.self, forCellReuseIdentifier: RecentKeywordTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var divideLine = DivideLine(frame: .zero, backgroundColor: .kerdyGray01)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        searchTF.becomeFirstResponder()
        
        recentDiscriptionView.clearButton.addTarget(
            self,
            action: #selector(recentClearBtnTapped),
            for: .touchUpInside
        )
        
        clearButton.addTarget(
            self,
            action: #selector(tfClearBtnTapped),
            for: .touchUpInside
        )
    }
    
    private func configureHidden(isSearching: Bool) {
        itemCountContainerView.isHidden = isSearching
        recentDiscriptionView.isHidden = !isSearching
    }
    
    @objc private func tfClearBtnTapped() {
        searchTF.text = nil
    }
    
    @objc private func recentClearBtnTapped() {

    }
}

// MARK: - layout 설정
extension SearchEventViewController {
    private func setLayout() {
        view.addSubviews(
            navigationBar,
            searchView,
            descriptionView,
            tableView,
            noResultImage
        )
        
        setSearchViewLayout()
        setDescriptionView()
        
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
        }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(17)
            $0.height.equalTo(46)
        }
        
        descriptionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(17)
            $0.top.equalTo(searchView.snp.bottom).offset(16)
            $0.height.equalTo(34)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(descriptionView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        noResultImage.snp.makeConstraints {
            $0.width.equalTo(126)
            $0.height.equalTo(101)
            $0.center.equalToSuperview()
        }
    }
    
    private func setSearchViewLayout() {
        searchView.addSubviews(
            searchImage,
            searchTF,
            clearButton
        )
        
        searchImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(13.25)
            $0.size.equalTo(19.5)
        }
        
        clearButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-14)
            $0.size.equalTo(18)
        }
        
        searchTF.snp.makeConstraints {
            $0.leading.equalTo(searchImage.snp.trailing).offset(9)
            $0.trailing.equalTo(clearButton.snp.leading).offset(-9)
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    private func setDescriptionView() {
        descriptionView.addSubviews(
            itemCountContainerView,
            recentDiscriptionView,
            divideLine
        )
        
        itemCountContainerView.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview()
        }
        
        recentDiscriptionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        divideLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.horizontalEdges.equalTo(view)
            $0.bottom.equalToSuperview()
        }
    }
}
// MARK: - tableViewDelegate

extension SearchEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
// MARK: - tableViewDataSource
extension SearchEventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 34
    }
}

// MARK: - 뒤로 가기 버튼 delegate
extension SearchEventViewController: BackButtonActionProtocol {
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SearchEventViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
