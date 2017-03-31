//
//  AdditionalProtocols.swift
//  Pods
//
//  Created by Thuyen Trinh on 3/31/17.
//
//

import Foundation

// MARK: - Optional
public protocol NTOptional {
    associatedtype Wrapped
    var nt_optional: Wrapped? { get }
}

// MARK: - Emptiable
public protocol Emptiable {
    var isEmpty: Bool { get }
}

// MARK: - Zeroable
public protocol Zeroable {
    var isZero: Bool { get }
}
