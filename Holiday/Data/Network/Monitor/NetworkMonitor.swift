//
//  NetworkMonitor.swift
//  Holiday
//
//  Created by 김도형 on 2/18/25.
//

import Foundation
import Network

final class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private var continuation: AsyncStream<NWPath>.Continuation?
    
    deinit {
        monitor.cancel()
        continuation?.finish()
    }
    
    func monitoringStart() {
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
    
    var monitoringHandler: AsyncStream<NWPath> {
        return AsyncStream { continuation in
            self.continuation = continuation
            monitor.pathUpdateHandler = { path in
                continuation.yield(path)
            }
        }
    }
}
