//
//  FilterBtn.swift
//  Kerdy
//
//  Created by 이동현 on 11/6/23.
//

import UIKit

final class FilterBtn: PrortudingBtn {

    init(title: String) {
        super.init(title: title, titleColor: .black, fontSize: 13, backgroundColor: .white)
        setTitleColor(.black, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setLayer() {
        super.setLayer(
            topLeft: 12,
            topRight: 20,
            bottomLeft: 20,
            bottomRight: 12,
            strokeColor: .kerdyMain
        )
    }
}
