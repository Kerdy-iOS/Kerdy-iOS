//
//  MyProfileManager.swift
//  Kerdy
//
//  Created by 최다경 on 1/4/24.
//

import UIKit
import Moya
import RxSwift

protocol MyProfileManagerType {
    
    func putDescription(description: String) -> Completable
    
    func deleteCategory(ids: [Int]) -> Completable
    
    func deleteActivityTag(id: Int) -> Completable
    
    func getMyActivities() -> Single<[ActivityResponse]>
    
    func getAllActivities() -> Single<[ActivityResponse]>
    
    func postMyActivities(ids: [Int]) -> Completable
    
    func updateProfileImage(image: UIImage) -> Completable
    
    func postInitialMember(ids: [Int], name: String) -> Completable
}

final class MyProfileManager: Networking, MyProfileManagerType {
    
    typealias API = MyProfileAPI
    
    static let shared = MyProfileManager()
    
    private let disposeBag = DisposeBag()
    
    private let provider = NetworkProvider<API>(plugins: [NetworkLogging()])
    
    private init () {}
    
    func putDescription(description: String) -> Completable {
        return provider
            .request(.description(description: description))
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }
    
    func deleteCategory(ids: [Int]) -> Completable {
        return provider
            .request(.deleteInterestTag(ids: ids))
            .asCompletable()
    }
    
    func deleteActivityTag(id: Int) -> Completable {
        return provider
            .request(.deleteActivityTag(id: id))
            .asCompletable()
    }
    
    func getMyActivities() -> Single<[ActivityResponse]> {
        return provider
            .request(.getMyActivities)
            .map([ActivityResponse].self)
    }

    func getAllActivities() -> Single<[ActivityResponse]> {
        return provider
            .request(.getAllActivities)
            .map([ActivityResponse].self)
    }
    
    func postMyActivities(ids: [Int]) -> Completable {
        return provider
            .request(.postMyActivities(ids: ids))
            .asCompletable()
    }
    
    func updateProfileImage(image: UIImage) -> Completable {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return .error(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cannot convert image to Data."]))
        }
        
        let multipartData = MultipartFormData(provider: .data(imageData), name: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        
        return provider
            .request(.updateProfileImage(image: multipartData))
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }
    
    func postInitialMember(ids: [Int], name: String) -> Completable {
        return provider
            .request(.postInitialMember(ids: ids, name: name))
            .asCompletable()
    }
}

