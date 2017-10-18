//
//  HNComment.swift
//  iOSLearningKit
//
//  Created by Thuyen Trinh on 4/1/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

final class HNComment: Object, HNLinkedResource {
    @objc dynamic var id: HNResourceID = 0
    @objc dynamic var author: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic fileprivate var _kidIdsString: String = ""
    
    var kidIds: [HNResourceID] {
        get  {  return _kidIdsString.components(separatedBy: ",").flatMap { HNResourceID($0) } }
        set {   _kidIdsString = kidIds.map { String($0) }.joined(separator: ",") }
    }
    
    init(json: JSON) throws {
        guard let id = json["id"].int else { throw NTJSONDecodableError.invalidJSON }
        super.init()
        self.id = id
        self.author = json["by"].stringValue
        self.content = json["text"].stringValue
        self.createdAt = Date(timeIntervalSince1970: json["time"].doubleValue)
        
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
        return content
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

extension HNComment: Cloneable {
    func cloned() -> HNComment {
        let object = HNComment()
        object.id = id
        object.author = author
        object.content = content
        object.createdAt = createdAt
        object.kidIds = kidIds
        object._kidIdsString = _kidIdsString
        return object
    }
}
