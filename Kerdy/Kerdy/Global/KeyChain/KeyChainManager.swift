//
//  KeyChainManager.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/26/23.
//

import Foundation

struct KeyChainManager {
    
    static let service = Bundle.main.bundleIdentifier
    
    // MARK: - save keychain
    
    static func save(forKey key: KeyChainValue, value: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: value.data(using: .utf8) as Any
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        switch status {
        case errSecSuccess:
            print("🔵 SAVE - 성공 🔵 🔑 \(key) ")
        case errSecDuplicateItem:
            print("🟡 SAVE - Duplicate & Update 성공 🟡 🔑 \(key) ")
            // 이미 존재하는 경우 update
            let updateQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service as AnyObject,
                kSecAttrAccount as String: key.rawValue
            ]
            
            let attributes: [String: Any] = [
                kSecValueData as String: value.data(using: .utf8) as Any
            ]
            
            let updateStatus =  SecItemUpdate(updateQuery as CFDictionary, attributes as CFDictionary)
            if updateStatus != errSecSuccess {
                print("❌ SAVE - Update 실패 ❌ 🔑 \(key) ")
            }
            
        default:
            print("❌ SAVE - 실패 ❌ 🔑 \(SecCopyErrorMessageString(status, nil).debugDescription) ")
        }
    }
    
    // MARK: - read Keychain
    
    static func read(forkey key: KeyChainValue) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecAttrService as String: service as Any,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        #if DEBUG
        switch status {
        case errSecSuccess:
            print("🔵 READ - 성공 🔵 🔑 \(key) ")
        case errSecItemNotFound:
            print("❌ READ - ItemNotFound ❌ 🔑 \(key) ")
            return ""
        default:
            print("❌ READ - 실패 ❌ 🔑 \(SecCopyErrorMessageString(status, nil).debugDescription) ")
            return ""
        }
        #endif
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            if let token = String(data: data, encoding: .utf8) {
                return token
            }
        }
        
        return nil
    }
    
    static func delete(forKey key: KeyChainValue) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service as Any,
            kSecAttrAccount: key.rawValue
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        #if DEBUG
        switch status {
        case errSecSuccess:
            print("🔵 DELETE - 성공 🔵 🔑 \(key) ")
        case errSecItemNotFound:
            print("❌ DELETE - ItemNotFound ❌ 🔑 \(key) ")
        default:
            print("❌ DELETE - 실패 ❌ 🔑 \(SecCopyErrorMessageString(status, nil).debugDescription) ")
        }
        #endif
    }
    
    static func hasKeychain(forkey key: KeyChainValue) -> Bool {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as Any,
            kSecAttrAccount as String: key.rawValue
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        
        #if DEBUG
        switch status {
        case errSecSuccess, errSecDuplicateItem:
            print("🔵 Exist - 성공 🔵 🔑 \(key) ")
            return true
        case errSecItemNotFound:
            print("❌ Exist - ItemNotFound ❌ 🔑 \(key) ")
            return false
        default:
            print("❌ Exist - 실패 ❌ 🔑 \(SecCopyErrorMessageString(status, nil).debugDescription) ")
            return false
        }
        #endif
    }
}

extension KeyChainManager {
    
    static func removeAllKeychain() {
        Self.delete(forKey: .accessToken)
        Self.delete(forKey: .memberId)
    }
    
    static func loadAccessToken() -> String {
        "Bearer " + (Self.read(forkey: .accessToken) ?? "")
    }
    
    static func loadMemberID() -> String {
        Self.read(forkey: .memberId) ?? ""
    }
}
