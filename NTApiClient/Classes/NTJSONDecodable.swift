//
//  NTJSONDecodable.swift
//  Pods
//
//  Created by Thuyen Trinh on 3/31/17.
//
//

import Foundation
import SwiftyJSON

// MARK: - NTJSONDecodable
public enum NTJSONDecodableError: Error {
    case invalidJSON
}

public protocol NTJSONDecodable {
    init(json: JSON) throws
}

extension NTJSONDecodable {
    static func from(json: JSON) -> Self? {
        do {
            return try Self(json: json)
        } catch {
            return nil
        }
    }
}
