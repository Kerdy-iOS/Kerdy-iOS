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
    
    func getMemger(id: Int) -> Single<MemberProfileResponseDTO>
}

final class SettingManager: Networking, SettingManagerType {
    
    typealias API = SettingAPI
    
    static let shared = SettingManager()
    
    private let disposeBag = DisposeBag()
    
    private let provider = NetworkProvider<API>(plugins: [NetworkLogging()])
    
    private init () {}
    
    func getMemger(id: Int) -> Single<MemberProfileResponseDTO> {
        return provider
            .request(.profile(id: id))
            .map(MemberProfileResponseDTO.self)
    }
}
