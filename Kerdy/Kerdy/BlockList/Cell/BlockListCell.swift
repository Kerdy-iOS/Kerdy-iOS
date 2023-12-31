//
//  BlockListCell.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import UIKit

import Core
import SnapKit
import Kingfisher

import RxCocoa
import RxSwift

protocol BlockCellDelegate: AnyObject {
    
    func tapBlockButton(indexPath: Int)
}

final class BlockListCell: UICollectionViewCell {
    
    // MARK: - Property
    
    private let disposeBag = DisposeBag()
    weak var delegate: BlockCellDelegate?
    
    private var indexPah: Int = 0
    
    // MARK: - UI Property
    
    fileprivate lazy var blockButton = UIButton()
    
    private let profile: UIImageView = {
        let image = UIImageView()
        image.makeCornerRound(radius: 48/2)
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private let userID: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(to: .bold, size: 15)
        label.textColor = .kerdyBlack
        return label
    }()
    
    // MARK: - Initialize
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        configureButton(isTapped: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setLayout()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension BlockListCell {
    
    private func setLayout() {
        
        contentView.addSubview(profile)
        profile.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(17)
            $0.size.equalTo(48)
        }
        
        contentView.addSubview(userID)
        userID.snp.makeConstraints {
            $0.leading.equalTo(profile.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(blockButton)
        blockButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(17)
            $0.size.equalTo(CGSize(width: 109, height: 30))
        }
    }
    
    private func setUI() {
        
        contentView.backgroundColor = .kerdyBackground
        configureButtonBindings()
        configureButton(isTapped: false)
    }
    
    func configureCell(to data: BlockReponseDTO, indexPath: Int) {
        
        self.indexPah = indexPath
        guard let url = URL(string: data.imageURL ?? "") else { return }
        profile.kf.setImage(with: url, placeholder: UIImage.emptyIcon)
        userID.text = data.name
        configureButton(isTapped: !data.isSelected)
    }
}

// MARK: - Button Style

extension BlockListCell {
    
    private func configureButtonBindings() {
        
        blockButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.delegate?.tapBlockButton(indexPath: self.indexPah)
            })
            .disposed(by: disposeBag)
    }
    
    func configureButton(isTapped: Bool) {
        
        let title = isTapped ? Strings.block : Strings.unblock
        let background = isTapped ? UIColor.kerdyBackground : UIColor.kerdyMain
        let foreground = isTapped ? UIColor.kerdyMain : UIColor.kerdyBackground
        let stroke = UIColor.kerdyMain
        
        self.blockButton.configuration = UIButton.kerdyStyle(to: title,
                                                             withBackground: background,
                                                             withForeground: foreground,
                                                             withStroke: stroke,
                                                             using: 1.0,
                                                             font: .nanumSquare(to: .bold, size: 11))
    }
}
