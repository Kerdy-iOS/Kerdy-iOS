//
//  SettingBasicModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 10/31/23.
//

import UIKit

struct BasicModel {
    
    let title: String
    var image: UIImage? = nil
    var version: String? = ""
    
    static var version: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String
        else { return nil }
        return version
    }
    
    static let basicWithIcon: [BasicModel]  = [BasicModel(title: "알림설정", image: .arrowIcon),
                                               BasicModel(title: "차단 목록", image: .arrowIcon),
                                               BasicModel(title: "이용 약관", image: .arrowIcon)
                                               
    ]
    
    static let basic: [BasicModel] = [BasicModel(title: "버전정보", version: version ?? "0.0"),
                                      BasicModel(title: "계정 삭제"),
                                      BasicModel(title: "로그아웃")
    ]
}
