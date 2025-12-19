//
//  DefaultsStorage.swift
//  Halan-Twitter-Task
//
//  Created by Mohamed Salah on 19/12/2025.
//
import Foundation

public extension UserDefaults {
    enum Key: String {
        case authToken
        case refreshToken
        case tokenExpirationDate
    }

    func removeObject(forKey key: Key) {
        removeObject(forKey: key.rawValue)
    }

    var getAuthToken: String? {
        get {
            return string(forKey: Key.authToken.rawValue)
        }
        set {
            if let value = newValue {
                set(value, forKey: Key.authToken.rawValue)
            } else {
                removeObject(forKey: Key.authToken.rawValue)
            }
        }
    }

    var getRefreshToken: String? {
        get {
            return string(forKey: Key.refreshToken.rawValue)
        }
        set {
            if let value = newValue {
                set(value, forKey: Key.refreshToken.rawValue)
            } else {
                removeObject(forKey: Key.refreshToken.rawValue)
            }
        }
    }
    
    var tokenExpirationDate: Date? {
        get {
            return object(forKey: Key.tokenExpirationDate.rawValue) as? Date
        }
        set {
            if let value = newValue {
                set(value, forKey: Key.tokenExpirationDate.rawValue)
            } else {
                removeObject(forKey: Key.tokenExpirationDate.rawValue)
            }
        }
    }
    
}
