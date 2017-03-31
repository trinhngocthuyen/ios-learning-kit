//
//  Foundation_Extensions.swift
//  NTKit
//
//  Created by Thuyen Trinh on 03/31/2017.
//  Copyright (c) 2017 Thuyen Trinh. All rights reserved.
//

import Foundation

// MARK: - Array
extension Array {
    public func split(size: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, self.count)])
        }
    }
}

// MARK: - Sequence
extension Sequence {
    public func groupBy<U>(_ groupingFunction: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
        var dict: [U: [Iterator.Element]] = [:]
        for element in self {
            let groupKey = groupingFunction(element)
            if let array = dict[groupKey] {
                dict[groupKey] = array + [element]
            } else {
                dict[groupKey] = [element]
            }
        }
        
        return dict
    }
}

// MARK: - Dictionary
extension Dictionary {
    public func toPairs() -> [(Key, Value)] {
        return self.map { key, value in (key, value) }
    }
    
    /// Merge 2 dictionaries, if conflictions happen (ex: value exist in the 2 dicts for a key), choose mine
    public func mergedChooseMine(with other: Dictionary?) -> Dictionary {
        var result = other ?? [:]
        for (key, value) in self {
            result[key] = value
        }
        return result
    }
}

// MARK: - IndexSet
extension IndexSet {
    public static func from(_ ints: [Int]) -> IndexSet {
        var indexSet = IndexSet()
        ints.forEach { indexSet.insert($0) }
        return indexSet
    }
}

// MARK: - Optional of (Emptiable - Zeroable)
extension Optional: NTOptional {
    public var nt_optional: Wrapped? { return self }
}

extension NTOptional where Wrapped: Emptiable {
    public var isNilOrEmpty: Bool {
        return nt_optional?.isEmpty ?? true
    }
}

extension NTOptional where Wrapped: Zeroable {
    public var isNilOrZero: Bool {
        return nt_optional?.isZero ?? true
    }
}
