//
//  PhotoRequest.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

struct PhotoRequest: Encodable {
    let query: String
    let page: Int = 1
    let perPage: Int = 1
}
