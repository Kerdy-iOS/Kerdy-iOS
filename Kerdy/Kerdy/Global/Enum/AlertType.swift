//
//  AuthType.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/17/23.
//

import Foundation

enum AlertType: Int, CaseIterable {
    case logout, withdrawal, report, delete, modify, plain
    
    var title: String {
        switch self {
        case .logout:
            return "로그아웃"
        case .withdrawal:
            return "계정 삭제"
        case .report:
            return "신고 하기"
        case .delete:
            return "댓글 삭제"
        case .modify, .plain:
            return ""
        }
    }
    
    var subTitle: String {
        switch self {
        case .logout:
            return "정말로 로그아웃 하시겠습니까?"
        case .withdrawal:
            return "정말로 계정을 삭제 하시겠습니까?\n계정 삭제 시 복구가 불가합니다."
        case .report:
            return "해당 댓글을 신고 하시겠습니까?"
        case .delete:
            return "해당 댓글을 삭제 하시겠습니까?"
        case .modify, .plain:
             return ""
        }
    }
    
    var button: String {
        switch self {
        case .logout:
            return "로그아웃"
        case .withdrawal, .delete:
            return "삭제"
        case .report:
            return "신고"
        case .modify:
            return "수정"
        case .plain:
            return ""
        }
    }
}
