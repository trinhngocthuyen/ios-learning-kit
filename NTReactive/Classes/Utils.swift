//
//  Utils.swift
//  Pods
//
//  Created by Thuyen Trinh on 3/31/17.
//
//

import Foundation
import ReactiveSwift

/// Convert a completion to a SignalProducer
/// Often used with currying
public func toRACStyle<A, V, E>(_ f: @escaping (A) -> ((V?, E?) -> Void) -> Void) -> (A) -> SignalProducer<V, E> {
    return { x in
        return SignalProducer { observer, disposable in
            let g = f(x); g { data, error in
                if let error = error {
                    observer.send(error: error)
                } else if let data = data {
                    observer.send(value: data)
                } else {
                    // Unexpected case
                    fatalError("Cannot convert to RAC style. Both data and error is nil!")
                }
            }
        }
    }
}
