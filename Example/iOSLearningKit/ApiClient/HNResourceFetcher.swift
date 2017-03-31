//
//  HNResourceFetcher.swift
//  iOSLearningKit
//
//  Created by Thuyen Trinh on 4/1/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

// MARK: - HNLinkedResourceFetchable (Protocol)
protocol HNLinkedResourceFetchable {
    associatedtype Resource: HNLinkedResource
    typealias IDType = Resource.IDType
    func fetchResource(id: IDType) -> SignalProducer<Resource, NSError>
}

// MARK: - StoryFetcher
final class HNStoriesFetcher: HNLinkedResourceFetchable {
    func fetchResource(id: HNResourceID) -> SignalProducer<HNStory, NSError> {
        let urlString = HNApiEndPoint.storyById.urlString(params: "\(id)")
        return rac_request(urlString)
            //.rac_log(identifier: "--- fetchStories: \(id)", events: [.started, .completed])
    }
}

// MARK: - CommentFetcher
final class HNCommentsFetcher: HNLinkedResourceFetchable {
    func fetchResource(id: HNResourceID) -> SignalProducer<HNComment, NSError> {
        let urlString = HNApiEndPoint.commentById.urlString(params: "\(id)")
        return rac_request(urlString)
            //.rac_log(identifier: "--- fetchComments: \(id)", events: [.started, .completed])
    }
}

extension HNLinkedResourceFetchable {
    func fetchResources<S>(ids: S)
        -> SignalProducer<Resource, NSError>
        where S: Sequence, S.Iterator.Element == Self.IDType
    {
        let producers = ids.map { fetchResource(id: $0) }
        return SignalProducer.concat(producers)
    }
}
