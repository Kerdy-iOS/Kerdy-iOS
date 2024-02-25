//
//  ImageManager.swift
//  Kerdy
//
//  Created by 이동현 on 12/24/23.
//

import UIKit
import RxSwift
import Moya

final class ImageManager {
    static let shared = ImageManager()
    private let provider = MoyaProvider<ImageAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    func getImage(url: String) -> Single<UIImage> {
        return provider.rx.request(.getImage(url: url))
            .map { response in
                return UIImage(data: response.data) ?? .eventOn
            }
    }
    
    func getProfileImage(url: String) -> Single<UIImage> {
        return provider.rx.request(.getProfileImage(url: url))
            .map { response in
                return UIImage(data: response.data) ?? .eventOn
            }
    }
}
