//
//  StoryDetailViewModel.swift
//  iOSLearningKit
//
//  Created by Thuyen Trinh on 4/1/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

final class StoryDetailViewModel: NSObject {
    var story: HNStory
    let apiClient: HNApiClient
    fileprivate var availableComments: [HNResourceID: HNComment] = [:]
    
    init(story: HNStory, apiClient: HNApiClient) {
        self.story = story
        self.apiClient = apiClient
    }
    
    func fetchComments() -> SignalProducer<[HNComment], NSError> {
        let realmToSave = Realm.tryCreate()
        let idsToFetch = story.kidIds.prefix(20)    // TODO: Load more
        
        let localComments = loadCommentsFromLocal(ids: idsToFetch)
        localComments.forEach { availableComments[$0.id] = $0 }
        
        let remoteItemsProducer = apiClient.fetchComments(ids: idsToFetch)
            .onValue { [weak self] comment in
                // Save to local
                comment.saveToLocal(with: realmToSave)
                // Update availabelComments
                self?.availableComments[comment.id] = comment
        }
        //.rac_log(identifier: "--- fetchComments", events: [.value, .failed])
        
        // The order in the ids is the order we display in UI. What an api!!!
        // To make sure comments are in order (corresponding those in story.kids)
        let updatedItemsProducer = remoteItemsProducer
            .scan([]) { _, _ in return idsToFetch.flatMap { self.availableComments[$0] } }
        
        return SignalProducer(value: localComments)
            .concat(updatedItemsProducer)
        
    }
    
    func loadCommentsFromLocal<S>(ids: S) -> [HNComment]
        where S: Sequence, S.Iterator.Element == HNResourceID
    {
        guard let realm = Realm.tryCreate() else { return [] }
        
        return realm.objects(HNComment.self)
            .filter("id in %@", Array(ids))
            .map { $0.cloned() }
    }
    
}
