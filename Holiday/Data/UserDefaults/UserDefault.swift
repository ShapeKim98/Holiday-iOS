//
//  UserDefault.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T?
    
    init(forKey: String, defaultValue: T? = nil) {
        self.key = forKey
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get { (UserDefaults.standard.object(forKey: key) as? T) ?? defaultValue }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: key)
            } else {
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
    }
}

enum UserDefaultsKey: String, CaseIterable {
    case cityId = "CityId"
}

extension String {
    static func userDefaults(_ key: UserDefaultsKey) -> String {
        key.rawValue
    }
}
