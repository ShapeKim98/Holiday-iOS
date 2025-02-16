//
//  Bundle+Extension.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

extension Bundle {
    var openweatherAppId: String {
        return infoDictionary?["OPENWEATHER_APP_ID"] as? String ?? ""
    }
    
    var unsplashClientId: String {
        return infoDictionary?["UNSPLASH_CLIENT_ID"] as? String ?? ""
    }
}
