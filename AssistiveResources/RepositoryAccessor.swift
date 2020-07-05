//
//  RepositoryAccessor.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/18/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit
import RealmSwift

protocol RepositoryAccessorProtocol: class {
    func notifyRepositoryWasUpdated()
}
/*
// generic class for all object accessors
class RepositoryAccess <T: Object, Cacheable> {
    var cachedElements: [T]?
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
            let events = uiRealm.objects(T.self)
            for event in events {
                cachedElements?.append(event)
            }
        } catch let error as NSError {
            // handle error
            let _ = error
        }
    }
}
*/
