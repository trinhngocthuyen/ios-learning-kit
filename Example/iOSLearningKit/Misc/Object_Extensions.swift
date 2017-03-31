//
//  Object_Extensions.swift
//  iOSLearningKit
//
//  Created by Thuyen Trinh on 4/2/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

protocol Cloneable {
    func cloned() -> Self
}

extension Realm {
    static func tryCreate() -> Realm? {
        do { return try Realm() }
        catch {
            NSLog("TryCreate. Failed with error: \(error)")
            return nil
        }
    }
    
    func tryWrite(_ block: () -> Void) {
        do {
            try self.write(block)
        } catch let error as NSError {
            NSLog("TryWrite. Failed with error: \(error)")
        }
    }
}

extension Cloneable where Self: Object {
    func saveToLocal(with realm: Realm?) {
        //NSLog("--- saveToLocal: \(self)")
        
        var realmToWrite = realm
        if realm == nil { realmToWrite = Realm.tryCreate() }
        
        if let realmToWrite = realmToWrite {
            realmToWrite.tryWrite {
                realmToWrite.add(cloned(), update: true)
            }
        }
    }
}

