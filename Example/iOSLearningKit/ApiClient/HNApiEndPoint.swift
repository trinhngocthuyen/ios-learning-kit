//
//  HNApiEndPoint.swift
//  iOSLearningKit
//
//  Created by Thuyen Trinh on 4/1/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

// MARK: - EndPoints
enum HNApiEndPoint {
    // tnthuyen: It's kind of weird when they (Hacker News team) design the apis
    // in which clients have to append `.json` to the endPoint
    case bestStoryIds
    case storyById
    case commentById
    
    var endpointFormat: String {
        switch self {
        case .bestStoryIds: return "https://hacker-news.firebaseio.com/v0/beststories.json"
        case .storyById:    return "https://hacker-news.firebaseio.com/v0/item/%@.json"
        case .commentById:  return "https://hacker-news.firebaseio.com/v0/item/%@.json" // The same as storyById
        }
    }
    
    func urlString(params: String...) -> String {
        return String(format: endpointFormat, arguments: params)
    }
}
