//
//  RepositoryAccessor.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/18/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit

enum LocalStoreState {
    case notLoaded, loaded
}

protocol RepositoryAccessorProtocol: class {
    func notifyRepositoryWasUpdated()
}


class RepositoryAccessor: NSObject {

    var localStoreState: LocalStoreState {
        guard let repoAvailable = repo?.localRepositoryAvailable, repoAvailable == true else {
            return .notLoaded
        }
        return haveLocalData() ? .loaded : .notLoaded
    }

    weak var repo: Repository?
    weak var delegate: RepositoryAccessorProtocol?
    
    init (repository: Repository, delegate: RepositoryAccessorProtocol) {
        
        super.init()
        self.repo = repository
        self.delegate = delegate
        
        let notificationkey = repository.repositoryUpdateNotificationKey()
        NotificationCenter.default.addObserver(self, selector: #selector(self.repositoryUpdateNotification), name: NSNotification.Name(rawValue: notificationkey), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func repositoryUpdateNotification() {
        fatalError("override \(#function)")
    }

    public func updateLocalCache(using filter: FilterDictionary) {
        fatalError("override \(#function)")
    }

    func haveLocalData() -> Bool {
        fatalError("override \(#function)")
    }

    func loadCache(using dictionary: FilterDictionary){
        guard localStoreState == .notLoaded else {
            return
        }
        updateLocalCache(using: dictionary)
    }
}
