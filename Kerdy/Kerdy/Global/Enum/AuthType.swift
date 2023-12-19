//
//  AuthType.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/17/23.
//

import Foundation

enum AuthType: Int, CaseIterable {
    case logout, withdrawal
    
    var title: String {
        switch self {
        case .logout:
            return "로그아웃"
        case .withdrawal:
            return "계정 삭제"
        }
    }
    
    var subTitle: String {
        switch self {
        case .logout:
            return "정말로 로그아웃 하시겠습니까?"
        case .withdrawal:
            return "정말로 계정을 삭제 하시겠습니까?\n계정 삭제 시 복구가 불가합니다."
        }
    }
    
    var button: String {
        switch self {
        case .logout:
            return "로그아웃"
        case .withdrawal:
            return "삭제"
        }
    }
}
