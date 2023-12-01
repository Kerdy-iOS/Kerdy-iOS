//
//  SettingBasicModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 10/31/23.
//

import UIKit

struct SettingBasicModel: Hashable {
    
    let title: String
    var image: UIImage?
    var version: String? = ""
    
    static var version: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String
        else { return nil }
        return version
    }
    
    static let basicWithIcon: [SettingBasicModel]  = [SettingBasicModel(title: "알림설정", image: .arrowIcon),
                                               SettingBasicModel(title: "차단 목록", image: .arrowIcon),
                                               SettingBasicModel(title: "이용 약관", image: .arrowIcon)
                                               
    ]
    
    static let basic: [SettingBasicModel] = [SettingBasicModel(title: "버전정보", version: version ?? "0.0"),
                                      SettingBasicModel(title: "계정 삭제"),
                                      SettingBasicModel(title: "로그아웃")
    ]
}
