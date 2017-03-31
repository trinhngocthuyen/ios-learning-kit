//
//  GCD_Extensions.swift
//  Pods
//
//  Created by Thuyen Trinh on 3/31/17.
//
//

import Foundation

public func delay(_ seconds: Double, queue: DispatchQueue = .main, execute: @escaping (Void) -> Void) {
    queue.asyncAfter(deadline: DispatchTime.now() + seconds, execute: execute)
}

public func dispatchMain(_ execute: @escaping (Void) -> Void) {
    DispatchQueue.main.async(execute: execute)
}
