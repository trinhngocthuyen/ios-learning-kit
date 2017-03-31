//
//  HomeViewModel.swift
//  iOSLearningKit
//
//  Created by Thuyen Trinh on 4/1/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

final class HomeViewModel: NSObject {
    let apiClient: HNApiClient
    fileprivate var availableStories: [HNResourceID: HNStory] = [:]
    fileprivate var availableIds: [HNResourceID] = []
    
    init(apiClient: HNApiClient) {
        self.apiClient = apiClient
        super.init()
    }
    
    func fetchBestStories() -> SignalProducer<[HNStory], NSError> {
        // TODO: Save ids of bestStories
        let realmToSave = Realm.tryCreate()
        return apiClient.fetchBestStoryIds()
            .map { $0.prefix(20) }  // FIXME: Load more (take the first 20 items for now)
            .flatMapConcat { ids in
                self.availableIds = Array(ids)
                let localItems = self.loadStoriesFromLocal(ids: ids)
                localItems.forEach { story in self.availableStories[story.id] = story }
                let localItemsProducer = SignalProducer<[HNStory], NSError>(value: localItems)
                
                let remoteItemsProducer = self.apiClient.fetchStories(ids: ids)
                    .onValue { [weak self] story in
                        // Save to local
                        story.saveToLocal(with: realmToSave)
                        // Update availableStories
                        self?.availableStories[story.id] = story
                    }
                
                // The order in the ids is the order we display in UI. What an api!!!
                let updatedItemsProducer = remoteItemsProducer
                    .scan([]) { _, _ in self.availableIds.flatMap { self.availableStories[$0] } }
                
                return localItemsProducer.concat(updatedItemsProducer)
            }
    }
    
    func loadStoriesFromLocal<S>(ids: S) -> [HNStory]
        where S: Sequence, S.Iterator.Element == HNResourceID
    {
        guard let realm = Realm.tryCreate() else { return [] }
        
        return realm.objects(HNStory.self)
            .filter("id in %@", Array(ids))
            .map { $0.cloned() }
    }
}
