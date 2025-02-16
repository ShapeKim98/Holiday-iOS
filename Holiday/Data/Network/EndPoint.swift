//
//  EndPoint.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

import Alamofire

protocol EndPoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var decoder: JSONDecoder { get }
}
