//
//  EventDetailViewController.swift
//  Kerdy
//
//  Created by 이동현 on 11/11/23.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - 상세정보, 댓글, 함께해요
enum EventDetailCategoryType: Int, CaseIterable {
    case photo
    case feed
    case recruitment

    var className: AnyClass {
        switch self {
        case .photo:
            return EventDetailPhotoCVCell.self
        case .feed, .recruitment:
            return EventDetailPostCVCell.self
        }
    }
    
    var identifier: String {
        switch self {
        case .photo:
            return EventDetailPhotoCVCell.identifier
        case .feed, .recruitment:
            return EventDetailPostCVCell.identifier
        }
    }
}

// MARK: - feed 화면으로 넘어가기 위한 delegate
protocol EventDetailShowFeedDelegate: AnyObject {
    func showFeed(feedId: Int)
}

// MARK: - VC
final class EventDetailViewController: BaseVC {
    // MARK: - UI Property
    private var navigationBar = NavigationBarView()
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    private var scrollContentView = UIView()
    private var titleImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .kerdyGray01
        image.layer.cornerRadius = 15
        return image
    }()
    private var summaryInfoView = EventSummaryInfoView()
    private lazy var categoryContainerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.addArrangedSubview(CategoryView(title: "상세정보", tag: 0))
        view.addArrangedSubview(CategoryView(title: "게시판", tag: 1))
        view.addArrangedSubview(CategoryView(title: "함께해요", tag: 2))

        for subview in view.arrangedSubviews {
            guard let categoryView = subview as? CategoryView else { continue }
            categoryView.button.addTarget(self, action: #selector(categoryBtnTapped), for: .touchUpInside)
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
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    private var addButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.backgroundColor = .kerdyMain
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()
    private var addButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "pencil")
        imageView.tintColor = .white
        return imageView
    }()
    private var bottomView = EventDetailBottomView()
    
    // MARK: - Property
    private var viewModel = EventDetailViewModel()
    weak var delegate: EventScrapDelegate?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setUI()
    }
    
    // MARK: - UI setting
    private func setUI() {
        view.backgroundColor = .systemBackground
        navigationBar.delegate = self
        scrollView.delegate = self
        collectionView.register(EventDetailPhotoCVCell.self, forCellWithReuseIdentifier: EventDetailPhotoCVCell.identifier)
        collectionView.register(EventDetailPostCVCell.self, forCellWithReuseIdentifier: EventDetailPostCVCell.identifier)
        bottomView.moveWebsiteBtn.addTarget(self, action: #selector(moveWebBtnTapped), for: .touchUpInside)
        bottomView.bookmarkBtn.addTarget(self, action: #selector(bookMarkBtnTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addBtnTapped), for: .touchUpInside)
        addButton.isHidden = true
        bindViewModel()
    }
    
    // MARK: - Method
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
            
            guard let cell = collectionView.visibleCells.first as? EventDetailCVCell else { return }
            cell.scrollTableViewToTop()
            cell.tableView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
     
        if index == EventDetailCategoryType.photo.rawValue {
            bottomView.isHidden = false
            addButton.isHidden = true
            
            scrollView.snp.remakeConstraints {
                $0.top.equalTo(navigationBar.snp.bottom)
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalTo(bottomView.snp.top)
            }
        } else {
            scrollView.snp.remakeConstraints {
                $0.top.equalTo(navigationBar.snp.bottom)
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
            bottomView.isHidden = true
            
            if index == EventDetailCategoryType.feed.rawValue {
                addButton.isHidden = true
            } else {
                addButton.isHidden = false 
            }
        }
    }
    
    func setViewModel(event: EventResponseDTO, isScrapped: Bool) {
        viewModel.setEvent(event)
        viewModel.setScrapState(isScrapped)
    }

    @objc private func categoryBtnTapped(_ sender: UIButton) {
        let tag = sender.tag
        let indexPath = IndexPath(item: tag, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateCategoryColor(index: tag)
    }
    
    @objc private func moveWebBtnTapped() {
        guard let event = viewModel.getEvent() else { return }
        let urlString = event.informationUrl
        
        guard
            let url = URL(string: urlString),
            UIApplication.shared.canOpenURL(url)
        else {
            let alert = UIAlertController(title: "알림", message: "등록된 URL이 없습니다.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction(cancel)
            self.present(alert, animated: true)
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc private func bookMarkBtnTapped() {
        viewModel.scrapButtonTapped()
    }
    
    @objc private func addBtnTapped() {
        let nextVC = CreateRecruitViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - layout 설정
extension EventDetailViewController {
    private func setLayout() {
        view.addSubviews(
            navigationBar,
            scrollView,
            bottomView,
            addButton
        )
        scrollView.addSubview(scrollContentView)
        setAddButtonLayout()
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
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        scrollContentView.snp.makeConstraints {
            let frameLayout = scrollView.frameLayoutGuide.snp
            let contentLayout = scrollView.contentLayoutGuide.snp
            $0.edges.equalTo(contentLayout.edges)
            $0.width.equalTo(frameLayout.width)
            $0.height.equalTo(100).priority(250)
        }
        
        addButton.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom ).offset(-25)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
                .offset(-25)
        }
    }
    
    private func setAddButtonLayout() {
        addButton.addSubview(addButtonImage)
        
        addButtonImage.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(15)
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
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(110).priority(500)
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
}

// MARK: - binding
extension EventDetailViewController {
    private func bindViewModel() {
        viewModel.event.subscribe(onNext: { [weak self] event in
            guard
                let self = self,
                let event = event
            else { return }
            
            if let thumbnailUrl = event.thumbnailUrl {
                setImage(url: thumbnailUrl)
            }
    
            summaryInfoView.configure(
                date: event.startDate,
                title: event.name,
                organization: event.organization,
                tags: event.tags
            )
        })
        .disposed(by: disposeBag)
        
        viewModel.feeds.subscribe(onNext: { [weak self] _ in
            self?.collectionView.reloadData()
        })
        .disposed(by: disposeBag)
        
        viewModel.recruitments.subscribe(onNext: { [weak self] _ in
            self?.collectionView.reloadData()
        })
        .disposed(by: disposeBag)
        
        viewModel.scrapState.subscribe(onNext: { [weak self] state in
            self?.bottomView.setBookMarkImage(isScrapped: state)
            self?.delegate?.scrapStateChanged()
        })
        .disposed(by: disposeBag)
    }
}

// MARK: - collectionView delegate
extension EventDetailViewController: UICollectionViewDelegate {
    
}

// MARK: - collectionView Layout delegate
extension EventDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return collectionView.frame.size
    }
}

// MARK: - collectionView dataSource
extension EventDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        var cellType: EventDetailCategoryType
        
        switch row {
        case EventDetailCategoryType.photo.rawValue:
            cellType = .photo
        case EventDetailCategoryType.feed.rawValue:
            cellType = .feed
        default:
            cellType = .recruitment
        }
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellType.identifier,
            for: indexPath
        )
        
        switch cellType {
        case .photo:
            if let cell = cell as? EventDetailPhotoCVCell {
                guard let event = viewModel.getEvent() else { return cell }
                cell.delegate = self
                cell.configure(with: event, cellType: .photo)
            }
            
        case .feed:
            if let cell = cell as? EventDetailPostCVCell {
                let feeds = viewModel.getFeeds()
                cell.delegate = self
                cell.configure(data: feeds, cellType: .feed)
            }
            
        case .recruitment:
            if let cell = cell as? EventDetailPostCVCell {
                let recruitments = viewModel.getRecruitments()
                cell.delegate = self
                cell.configure(data: recruitments, cellType: .recruitment)
            }
        }
        return cell
    }
}
// MARK: - scrollView delegate
extension EventDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else { return }
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        if let indexPath = visibleIndexPaths.first {
            let row = indexPath.row
            updateCategoryColor(index: row)
        }
    }
    
    func  scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }
        
        guard let cell = collectionView.visibleCells.first as? EventDetailCVCell else { return }
        
        guard let postType = cell.postType else { return }

        switch postType {
        case .photo:
            if let event = viewModel.getEvent() {
                if event.imageUrls.isEmpty { return }
            }
        case .feed:
            if viewModel.getFeeds().isEmpty { return }
        case .recruitment:
            if viewModel.getRecruitments().isEmpty { return }
        }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if offsetY + scrollViewHeight >= contentHeight {
            cell.tableView.isScrollEnabled = true
            self.scrollView.isScrollEnabled = false
        }
    }
}

// MARK: - navigationBar 뒤로 가기
extension EventDetailViewController: BackButtonActionProtocol {
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - title Image 처리
extension EventDetailViewController {
    private func setImage(url: String) {
        ImageManager.shared.getImage(url: url)
            .subscribe { [weak self] image in
                self?.titleImage.image = image
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - CommentVC로 이동하기 위한 delegate
extension EventDetailViewController: EventDetailShowFeedDelegate {
    func showFeed(feedId: Int) {
//        let commentVC = CommentsVC(viewModel: CommentsViewModel(commentID: feedId, commentsManager: CommentManager.shared))
//        self.navigationController?.pushViewController(commentVC, animated: true)
    }
}

// MARK: - tableView로부터 스크롤 정보를 받아오기 위한 delegate
extension EventDetailViewController: DataTransferDelegate {
    func dataTransfered(data: Any) {
        guard let isScrollViewScrollEnabled = data as? Bool else { return }
        guard let cell = collectionView.visibleCells.first as? EventDetailCVCell else { return }
        cell.tableView.isScrollEnabled = !isScrollViewScrollEnabled
        scrollView.isScrollEnabled = isScrollViewScrollEnabled
    }
}
