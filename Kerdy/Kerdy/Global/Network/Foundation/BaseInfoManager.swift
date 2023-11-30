//
//  BaseInfoManager.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/26/23.
//

import Foundation

enum BaseInfoKeys {
    static let clientID = "ClientID"
    static let callbackURLScheme = "CallbackURLScheme"
    static let baseURL = "BaseURL"
}

final class BaseInfoManager {
    
    static let shared = BaseInfoManager()
    
    class var clientID: String {
        guard let id = shared.info[BaseInfoKeys.clientID] else { fatalError("ClientID: Base-Info Plist error") }
        return id
    }
    
    class var callbackURLScheme: String {
        guard let scheme = shared.info[BaseInfoKeys.callbackURLScheme] else { fatalError("CallbackURLScheme: Base-Info Plist error") }
        return scheme
    }
    
    class var baseURL: String {
        guard let url = shared.info[BaseInfoKeys.baseURL] else { fatalError("BaseURL: Base-Info Plist error")}
        return url
    }

    private var info: [String: String] {
        guard let plistPath = Bundle.main.path(forResource: "Base-Info", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: plistPath) as? [String: String] else {
            return [:]
        }
        return plist
    }
}
