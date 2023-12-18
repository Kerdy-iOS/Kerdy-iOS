//
//  SettingManager.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/1/23.
//

import UIKit

import Moya
import RxSwift

protocol SettingManagerType {
    
    func getMember(id: Int) -> Single<MemberProfileResponseDTO>
    func deleteMember(id: Int) -> Single<Void>
}

final class SettingManager: Networking, SettingManagerType {
    
    typealias API = SettingAPI
    
    static let shared = SettingManager()
    
    private let disposeBag = DisposeBag()
    
    private let provider = NetworkProvider<API>(plugins: [NetworkLogging()])
    
    private init () {}
    
    func getMember(id: Int) -> Single<MemberProfileResponseDTO> {
        return provider
            .request(.profile(id: id))
            .map(MemberProfileResponseDTO.self)
    }
    
    func deleteMember(id: Int) -> Single<Void> {
        return provider
            .request(.withdrawal(id: id))
            .map { _ in }
    }
}
