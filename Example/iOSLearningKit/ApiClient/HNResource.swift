//
//  HNResource.swift
//  iOSLearningKit
//
//  Created by Thuyen Trinh on 4/1/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

protocol HNResource: NTJSONDecodable {
    associatedtype IDType
    var id: IDType { get }
}

protocol HNLinkedResource: HNResource {
    var kidIds: [IDType] { get }
}

