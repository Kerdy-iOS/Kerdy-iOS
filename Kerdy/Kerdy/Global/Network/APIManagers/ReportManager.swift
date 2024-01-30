//
//  ReportManager.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 1/11/24.
//

import Foundation

import RxSwift

protocol ReportManagerType {
    
    func postReport(request: ReportRequestDTO) -> Single<Void>
}

final class ReportManager: Networking, ReportManagerType {
    
    typealias API = ReportAPI
    
    static let shared = ReportManager()
    
    private let disposeBag = DisposeBag()
    
    private let provider = NetworkProvider<API>(plugins: [NetworkLogging()])
    
    private init () {}
    
    func postReport(request: ReportRequestDTO) -> Single<Void> {
        return provider
            .request(.postReport(request: request))
            .map { _ in }
    }
}
