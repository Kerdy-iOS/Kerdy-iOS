//
//  Networking.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/26/23.
//

import RxSwift
import RxMoya
import Moya

protocol Networking {
    associatedtype API: KerdyAPI
    
    func request(_ api: API, file: StaticString, function: StaticString, line: UInt) -> Single<Response>
}

extension Networking {
    
    func request(
        _ api: API,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) -> Single<Response> {
        self.request(api, file: file, function: function, line: line)
    }
}

final class NetworkProvider<API: KerdyAPI>: Networking {
    
    private let provider: MoyaProvider<API>
    
    init(plugins: [PluginType] = []) {
        self.provider = MoyaProvider(plugins: plugins)
    }
    
    /// file, function, line은 디버깅 목적
    /// file: 현재 소스 파일의 경로
    /// function: 현재 호출된 함수의 이름
    /// line: 현재 호출된 라인의 번호
    func request(
        _ api: API,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) -> Single<Response> {
        let requestString = "\(api.urlPath)"
        
        return provider.rx.request(api)
            .filterSuccessfulStatusCodes()
            .do(
                onSuccess: { response in
                    print("SUCCESS: \(requestString) (\(response.statusCode))")
                },
                onError: { _ in
                    print("ERROR: \(requestString)")
                },
                onSubscribed: {
                    print("REQUEST: \(requestString)")
                }
            )
    }
}
