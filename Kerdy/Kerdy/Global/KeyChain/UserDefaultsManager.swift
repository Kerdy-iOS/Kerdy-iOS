//
//  UserDefaultsManager.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 1/6/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    private let key: String
    private let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

enum UserDefaultKey: String, CaseIterable {
    case isFirstNotification
    case isNotification
    case isTagSelected
    case isCommentsSelected
    case isNoteSelected
}

enum UserDefaultStore {
    @UserDefault(key: UserDefaultKey.isFirstNotification.rawValue, defaultValue: false)
    static var isFirstNotification: Bool
    
    @UserDefault(key: UserDefaultKey.isNotification.rawValue, defaultValue: false)
    static var isNotification: Bool
    
    @UserDefault(key: UserDefaultKey.isTagSelected.rawValue, defaultValue: false)
    static var isTagSelected: Bool
    
    @UserDefault(key: UserDefaultKey.isCommentsSelected.rawValue, defaultValue: false)
    static var isCommentsSelected: Bool
    
    @UserDefault(key: UserDefaultKey.isNoteSelected.rawValue, defaultValue: false)
    static var isNoteSelected: Bool
}
