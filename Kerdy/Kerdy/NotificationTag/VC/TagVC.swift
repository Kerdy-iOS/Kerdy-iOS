//
//  TagVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/1/23.
//

import UIKit

import Core
import SnapKit

import RxSwift
import RxCocoa

final class TagVC: UIViewController {
    
    // MARK: - Property
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    private var dummyData: [TagType] = TagType.dummy()
    
    // MARK: - UI Property
    
    private let navigationView: NavigationBarView = {
        let view = NavigationBarView()
        view.configureUI(to: Strings.notificationTag)
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: TagCollectionViewFlowLayout())
        view.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.tag
        label.font = .nanumSquare(to: .bold, size: 15)
        label.textColor = .kerdyBlack
        return label
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.register, for: .normal)
        button.makeCornerRound(radius: 15)
        button.backgroundColor = .kerdyMain
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setUI()
    }
    
}

// MARK: - Methods

extension TagVC {
    
    private func setLayout() {
        
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeArea)
        }
        
        view.addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(20)
            $0.leading.equalTo(safeArea).inset(17)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(tagLabel.snp.bottom).offset(14)
            $0.horizontalEdges.equalTo(safeArea).inset(17)
            $0.bottom.equalTo(safeArea)
        }
        
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(safeArea).inset(17)
            $0.height.equalTo(60)
        }
        
    }
    
    private func setUI() {
        
        self.view.backgroundColor = .kerdyBackground
    }
    
}

extension TagVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as? TagCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(to: dummyData[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return dummyData[indexPath.item].title.insetSize(font: .nanumSquare(to: .regular, size: 13))
    }
}
