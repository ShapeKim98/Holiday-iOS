//
//  Effect.swift
//  Tamagotchi
//
//  Created by 김도형 on 2/21/25.
//

import Foundation

import RxSwift

protocol EffectProtocol {
    associatedtype Action
    static func send(_ action: Action) -> Self
    static var none: Self { get }
}

enum Effect<Action>: EffectProtocol {
    case send(Action)
    case none
    
    var action: Action? {
        switch self {
        case .send(let action):
            return action
        case .none: return nil
        }
    }
}

extension Observable where Element: EffectProtocol {
    static func send(_ action: Element.Action) -> Observable<Element> {
        return .just(.send(action))
    }
    
    static var none: Observable<Element> {
        return .just(.none)
    }
    
    static func run(
        _ observable: Observable<Element.Action>,
        catch onError: ((Error) -> Observable<Element>)? = nil
    ) -> Observable<Element> {
        return observable
            .map { Element.send($0) }
            .catch { onError?($0) ?? .none }
    }
    
    static func run(
        _ observable: Single<Element.Action>,
        catch onError: ((Error) -> Observable<Element>)? = nil
    ) -> Observable<Element> {
        return observable
            .map { Element.send($0) }
            .asObservable()
            .catch { onError?($0) ?? .none }
    }
    
    @MainActor
    static func run(
        priority: TaskPriority? = nil,
        _ operation: sending @escaping ( _ effect: AnyObserver<Element>) async throws -> Void,
        catch onError: ((Error) -> Element)? = nil
    ) -> Observable<Element> {
        return .create { observable in
            Task(priority: priority) {
                do {
                    try await operation(observable)
                    observable.onCompleted()
                } catch {
                    observable.onNext(onError?(error) ?? .none)
                    observable.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    static func merge(
        _ observables: Observable<Element.Action>...
    ) -> Observable<Element> {
        let creates = observables.map { observable in
            observable.map { Element.send($0) }
        }
        return .merge(creates)
    }
    
    static func concatenate(
        _ observables: Observable<Element.Action>...
    ) -> Observable<Element> {
        let creates = observables.map { observable in
            observable.map { Element.send($0) }
        }
        return .concat(creates)
    }
}
