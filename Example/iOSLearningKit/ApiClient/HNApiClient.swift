//
//  HNApiClient.swift
//  iOSLearningKit
//
//  Created by Thuyen Trinh on 4/1/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

// MARK: - HNApiClient
final class HNApiClient: NSObject {
    
    private let storiesFetcher: HNStoriesFetcher
    private let commentsFetcher: HNCommentsFetcher
    
    init(storiesFetcher: HNStoriesFetcher = .init(), commentsFetcher: HNCommentsFetcher = .init()) {
        self.storiesFetcher = storiesFetcher
        self.commentsFetcher = commentsFetcher
    }
    
    // MARK: - APIs
    func fetchBestStoryIds() -> SignalProducer<[HNResourceID], NSError> {
        let urlString = HNApiEndPoint.bestStoryIds.urlString()
        return rac_requestJSON(urlString)
            .flatMapLatest { json -> SignalProducer<[HNResourceID], NSError> in
                if let jsonArray = json.array {
                    return SignalProducer(value: jsonArray.map { $0.intValue })
                }
                return SignalProducer(error: NTJSONDecodableError.invalidJSON as NSError)
        }
    }
    
    func fetchStories<S>(ids: S)
        -> SignalProducer<HNStory, NSError>
        where S: Sequence, S.Iterator.Element == HNResourceID
    {
        return storiesFetcher.fetchResources(ids: ids)
    }
    
    func fetchComments<S>(ids: S)
        -> SignalProducer<HNComment, NSError>
        where S: Sequence, S.Iterator.Element == HNResourceID
    {
        // TODO: How to fetch nestedly (ie: fetch comments which is a child/kid of a comment)?
        return commentsFetcher.fetchResources(ids: ids)
    }
}


