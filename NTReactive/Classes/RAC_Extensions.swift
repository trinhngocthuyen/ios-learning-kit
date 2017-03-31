//
//  RAC_Extensions.swift
//  NTKit
//
//  Created by Thuyen Trinh on 03/31/2017.
//  Copyright (c) 2017 Thuyen Trinh. All rights reserved.
//

import ReactiveSwift

func nt_racLogger(identifier: String, event: String, fileName: String, functionName: String, lineNumber: Int) {
    NSLog("[\(identifier)] \(event)")
}

// MARK: - SignalProducerProtocol
extension SignalProducerProtocol {
    
    public func rac_log(identifier: String, events: Set<LoggingEvent.SignalProducer> = [.started, .value, .failed]) -> SignalProducer<Value, Error> {
        return logEvents(identifier: identifier, events: events, logger: nt_racLogger)
    }
    
    // MARK: - Life cylce
    @discardableResult
    @inline(__always)
    public func startWithValue(_ onValue: @escaping (Value) -> Void) -> Disposable {
        return on(value: onValue).start()
    }
    
    @inline(__always)
    public func onStarted(_ started: @escaping (Void) -> Void) -> SignalProducer<Value, Self.Error> {
        return on(started: started)
    }
    
    @inline(__always)
    public func onValue(_ value: @escaping (Value) -> Void) -> SignalProducer<Value, Self.Error> {
        return on(value: value)
    }
    
    @inline(__always)
    public func onCompleted(_ completed: @escaping (Void) -> Void) -> SignalProducer<Value, Self.Error> {
        return on(completed: completed)
    }
    
    @inline(__always)
    public func onFailed(_ failed: @escaping (Self.Error) -> Void) -> SignalProducer<Value, Self.Error> {
        return on(failed: failed)
    }
    
    @inline(__always)
    public func onDisposed(_ disposed: @escaping (Void) -> Void) -> SignalProducer<Value, Self.Error> {
        return on(disposed: disposed)
    }
    
    @inline(__always)
    public func onTerminated(_ terminated: @escaping (Void) -> Void) -> SignalProducer<Value, Self.Error> {
        return on(terminated: terminated)
    }
    
    @inline(__always)
    public func onInterrupted(_ interrupted: @escaping (Void) -> Void) -> SignalProducer<Value, Self.Error> {
        return on(interrupted: interrupted)
    }
    
    // MARK: - Scheduler
    @inline(__always)
    public func observeOnMain() -> SignalProducer<Value, Error> {
        return observe(on: QueueScheduler.main)
    }
    
    // MARK: - FlatMap
    @inline(__always)
    public func flatMapLatest<U>(_ transform: @escaping (Value) -> SignalProducer<U, Error>) -> SignalProducer<U, Error> {
        return flatMap(.latest, transform: transform)
    }
    
    @inline(__always)
    public func flatMapMerge<U>(_ transform: @escaping (Value) -> SignalProducer<U, Error>) -> SignalProducer<U, Error> {
        return flatMap(.merge, transform: transform)
    }
    
    @inline(__always)
    public func flatMapConcat<U>(_ transform: @escaping (Value) -> SignalProducer<U, Error>) -> SignalProducer<U, Error> {
        return flatMap(.concat, transform: transform)
    }
    
    // MARK: - Pack/Unpack
    @inline(__always)
    public static func from(_ values: [Value]) -> SignalProducer<Value, Error> {
        return SignalProducer(values)
    }
    
    @inline(__always)
    public static func concat(_ producers: [SignalProducer<Value, Error>]) -> SignalProducer<Value, Error> {
        return producers.reduce(.empty, { $0.concat($1) })
    }
    
    @inline(__always)
    public static func merge(_ producers: [SignalProducer<Value, Error>]) -> SignalProducer<Value, Error> {
        return SignalProducer(producers).flatten(.merge)
    }
}

// MARK: - Disposable
extension Disposable {
    public func addToBag(_ bag: CompositeDisposable) {
        bag.add(self)
    }
}
