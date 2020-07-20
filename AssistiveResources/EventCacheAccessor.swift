//
//  EventCacheAccessor.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/9/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit
import RealmSwift

class EventCacheAccessor: ElementCache {
    var cachedElements: [SPNEvent]?
    weak var repository: LocalRepository?
    weak var delegate: CacheUpdateProtocol?

    init (repository: LocalRepository, delegate: CacheUpdateProtocol) {
        self.repository = repository
        self.delegate = delegate

        let notificationkey = repository.repositoryUpdateNotificationKey()
        NotificationCenter.default.addObserver(self, selector: #selector(self.repositoryUpdateNotification), name: NSNotification.Name(rawValue: notificationkey), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func repositoryUpdateNotification() {
        let needProfile = FilterDictionary()
        loadCache(using: needProfile)
        delegate?.cacheUpdateNotification()
    }

    internal func loadCache(using filter: FilterDictionary) {
        cachedElements = []
        do {
            let uiRealm = try Realm()
            let events = uiRealm.objects(SPNEvent.self)
            for event in events {
                cachedElements?.append(event)
            }
        } catch let error as NSError {
            // handle error
            let _ = error
        }
    }
}

func uncachedEvent(withIdentifier identifier: Int) -> SPNEvent? {

    do {
        let uiRealm = try Realm()
        return uiRealm.objects(SPNEvent.self).first { $0.identifier == identifier }
    } catch {
        return nil
    }
}
