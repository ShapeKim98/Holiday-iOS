//
//  PresentState.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/1/25.
//

import Foundation

import RxSwift
import RxCocoa

@propertyWrapper
struct PresentState<State> {
    private var value: State {
        didSet { count += 1 }
    }
    private(set) var count = 1
    
    init(wrappedValue: State) {
        value = wrappedValue
    }
    
    var wrappedValue: State {
        get { value }
        set { value = newValue }
    }
    
    var projectedValue: PresentState<State> { self }
}
