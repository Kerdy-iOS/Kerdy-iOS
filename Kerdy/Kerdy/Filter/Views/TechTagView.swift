//
//  TechTagView.swift
//  Kerdy
//
//  Created by 이동현 on 11/6/23.
//

import UIKit

final class TechTagView: UIView {
    private var tagNames: [String] = [
        "백엔드",
        "프론트엔드",
        "안드로이드",
        "iOS",
        "AI",
        "알고리즘",
        "정보보호",
        "인프라",
        "디자인",
        "게임",
        "주니어 추천",
        "오픈소스",
        "메타버스",
        "빅데이터",
        "데이터",
        "소프트 스킬",
        "DevOps"
    ]

    private let tagHeight: CGFloat = 32
    private let tagPadding: CGFloat = 50
    private let tagSpacingX: CGFloat = 8
    private let tagSpacingY: CGFloat = 11

    private var intrinsicHeight: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        addTagLabels()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addTagLabels() {
        for name in tagNames {
            let newBtn = FilterBtn(title: name)
            addSubview(newBtn)
        }

        for view in subviews {
            guard
                let button = view as? FilterBtn
            else {
                fatalError("non-UIButton subview found!")
            }

            button.frame.size.width = button.intrinsicContentSize.width + tagPadding
            button.frame.size.height = tagHeight
        }
    }

    private func setButtonsLayout() {
        var currentOriginX: CGFloat = 0
        var currentOriginY: CGFloat = 0

        // for each label in the array
        self.subviews.forEach { view in
            guard
                let button = view as? UIButton
            else {
                fatalError("non-UIButton subview found!")
            }

            if currentOriginX + button.bounds.width > bounds.width {
                currentOriginX = 0
                currentOriginY += tagHeight + tagSpacingY
            }

            button.frame.origin.x = currentOriginX
            button.frame.origin.y = currentOriginY

            currentOriginX += button.frame.width + tagSpacingX
        }

        intrinsicHeight = currentOriginY + tagHeight
        invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = intrinsicHeight
        return size
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setButtonsLayout()
    }
}
