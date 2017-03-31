//
//  HNStory.swift
//  iOSLearningKit
//
//  Created by Thuyen Trinh on 4/1/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

typealias HNResourceID = Int

final class HNStory: Object, HNLinkedResource {
    dynamic var id: HNResourceID = 0
    dynamic var title: String = ""
    dynamic var urlString: String = ""
    dynamic var author: String = ""
    dynamic var createdAt: Date = Date()
    dynamic var score: Int = 0
    dynamic var nNestedComments: Int = 0
    dynamic fileprivate var _kidIdsString: String = ""
    
    dynamic var kidIds: [HNResourceID] {
        get  {  return _kidIdsString.components(separatedBy: ",").flatMap { HNResourceID($0) } }
        set {   _kidIdsString = kidIds.map { String($0) }.joined(separator: ",") }
    }
    
    init(json: JSON) throws {
        guard let id = json["id"].int else { throw NTJSONDecodableError.invalidJSON }
        super.init()
        self.id = id
        self.title = json["title"].stringValue
        self.urlString = json["url"].stringValue
        self.author = json["by"].stringValue
        self.createdAt = Date(timeIntervalSince1970: json["time"].doubleValue)
        self.score = json["score"].intValue
        self.nNestedComments = json["descendants"].intValue
        
        let _kidIds = json["kids"].arrayValue.map { $0.intValue }
        self._kidIdsString = _kidIds.map { String($0) }.joined(separator: ",")
        self.kidIds = _kidIds
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override class func ignoredProperties() -> [String] {
        return ["kidIds"]
    }
    
    override var description: String {
        return title
    }
    
    required init() {
        super.init()
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}

extension HNStory: Cloneable {
    func cloned() -> HNStory {
        let object = HNStory()
        object.id = id
        object.title = title
        object.urlString = urlString
        object.author = author
        object.createdAt = createdAt
        object.score = score
        object.nNestedComments = nNestedComments
        object.kidIds = kidIds
        object._kidIdsString = _kidIdsString
        return object
    }
}
