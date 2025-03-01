//
//  Composable.swift
//  Tamagotchi
//
//  Created by 김도형 on 2/23/25.
//

import Foundation

import RxSwift
import RxCocoa

@MainActor
protocol Composable: AnyObject {
    associatedtype Action
    associatedtype State
    
    var state: State { get set }
    var send: PublishRelay<Action> { get }
    var disposeBag: DisposeBag { get }
    
    func bindSend()
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>>
}

extension Composable {
    func bindSend() {
        send
            .observe(on: MainScheduler.asyncInstance)
            .debug("\(Self.self): Received Action")
            .withUnretained(self)
            .compactMap { this, action in
                var state = this.state
                this.reducer(&state, action)
                    .observe(on: MainScheduler.asyncInstance)
                    .compactMap(\.action)
                    .bind(to: this.send)
                    .disposed(by: this.disposeBag)
                return state
            }
            .bind(with: self) { this, state in
                this.state = state
            }
            .disposed(by: disposeBag)
    }
}
