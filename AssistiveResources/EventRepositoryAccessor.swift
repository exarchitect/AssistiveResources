//
//  EventRepositoryAccessor.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/9/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit
import RealmSwift

class EventRepositoryAccessor: ElementCache {
    var cachedElements: [StoredEvent]?
    weak var repository: Repository?
    weak var delegate: RepositoryAccessorProtocol?

    init (repository: Repository, delegate: RepositoryAccessorProtocol) {
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
        delegate?.notifyRepositoryWasUpdated()
    }

    func loadCache(using filter: FilterDictionary) {
        cachedElements = []
        do {
            let uiRealm = try Realm()
            let events = uiRealm.objects(StoredEvent.self)
            for event in events {
                cachedElements?.append(event)
            }
        } catch let error as NSError {
            // handle error
            let _ = error
        }
    }
}

func uncachedEvent(withIdentifier identifier: Int) -> StoredEvent? {

    do {
        let uiRealm = try Realm()
        return uiRealm.objects(StoredEvent.self).first { $0.identifier == identifier }
    } catch {
        return nil
    }
}

//func uncachedObject<T: Object>(withIdentifier identifier: Int) -> T? {
//
//    do {
//        let uiRealm = try Realm()
//        return uiRealm.objects(T.self).first { $0.identifier == identifier }
//    } catch {
//        return nil
//    }
//}
