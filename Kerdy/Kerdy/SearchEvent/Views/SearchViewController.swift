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

final class SearchEventViewController: BaseVC {
    // MARK: - UI Property
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
    
    // MARK: - Property
    private var viewModel = SearchEventViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        bindViewModel()
    }
    
    // MARK: - UI Setting
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
    
    // MARK: - Method
    private func configureHidden(isSearching: Bool) {
        itemCountContainerView.isHidden = isSearching
        recentDiscriptionView.isHidden = !isSearching
    }
    
    @objc private func tfClearBtnTapped() {
        searchTF.text = nil
    }
    
    @objc private func recentClearBtnTapped() {
        self.viewModel.removeRecentAll()
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
        if viewModel.isSearching.value {
            return viewModel.recentSearches.value.count
        } else {
            return viewModel.eventsRelay.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isSearching.value {
            let recentSearches = viewModel.recentSearches.value
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentKeywordTableViewCell.identifier, for: indexPath) as? RecentKeywordTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.configure(keyword: recentSearches[indexPath.row])
            cell.selectionStyle = .none
            return cell
        } else {
            let events = viewModel.eventsRelay.value
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier, for: indexPath) as? EventTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.configure(events[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.isSearching.value {
            let recentSearches = viewModel.recentSearches.value
            searchTF.text = recentSearches[indexPath.row]
            searchTF.becomeFirstResponder()
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! EventTableViewCell
            // 상세 페이지로 이동
        }
    }
}
// MARK: - tableViewDataSource
extension SearchEventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.isSearching.value ? 34 : 318
    }
}

// MARK: - binding
extension SearchEventViewController {
    private func bindViewModel() {
        viewModel.isSearching
            .subscribe(onNext: { [weak self] state in
                if state {
                    self?.noResultImage.isHidden = true
                    self?.tableView.isHidden = false
                    self?.tableView.separatorStyle = .none
                } else {
                    self?.tableView.separatorStyle = .singleLine
                    if
                        let keyword = self?.searchTF.text,
                        !keyword.isEmpty {
                        self?.viewModel.getEvents(keyword: keyword)
                    }
                }
                self?.configureHidden(isSearching: state)
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.eventsRelay
            .subscribe(onNext: { [weak self] events in
                let isSearcing = self?.viewModel.isSearching.value
                guard
                    let isSearching = isSearcing,
                    !isSearching
                else { return }
                
                if events.count == 0 {
                    self?.noResultImage.isHidden = false
                    self?.tableView.isHidden = true
                    self?.itemCountContainerView.setCount(count: 0)
                } else {
                    self?.noResultImage.isHidden = true
                    self?.tableView.isHidden = false
                    self?.itemCountContainerView.setCount(count: events.count)
                    self?.tableView.reloadData()
                }
            })
             .disposed(by: disposeBag)
        
        viewModel.recentSearches
            .subscribe(onNext: { [weak self] _ in
                let isSearcing = self?.viewModel.isSearching.value
                guard
                    let isSearching = isSearcing,
                    isSearching
                else { return }
                self?.tableView.reloadData()
            })
             .disposed(by: disposeBag)
        
        searchTF.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.isSearching.accept(true)
            })
            .disposed(by: disposeBag)

        searchTF.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [weak self] in
                if
                    let keyword = self?.searchTF.text,
                    !keyword.isEmpty
                {
                    self?.viewModel.addRecentSearch(keyword: keyword)
                }
                self?.viewModel.isSearching.accept(false)
            })
            .disposed(by: disposeBag)
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
        viewModel.isSearching.accept(false)
        return true
    }
}

// MARK: - data 전송 delegate
extension SearchEventViewController: DataTransferDelegate {
    func dataTransfered(data: Any) {
        guard let keyword = data as? String else { return }
        viewModel.deleteRecentSearch(keyword: keyword)
    }
}
