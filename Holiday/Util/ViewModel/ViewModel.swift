//
//  ViewModel.swift
//  TheMovie
//
//  Created by 김도형 on 2/7/25.
//

import Foundation

protocol ViewModel: AnyObject {
    associatedtype Input
    associatedtype Output
    associatedtype Model
    
    var model: Model { get }
    
    var output: AsyncStream<Output> { get }
    
    func input(_ action: Input)
}
