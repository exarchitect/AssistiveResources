//
//  RepositoryAccessor.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/18/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit

enum AccessorState : Int {
    case NotLoaded = 0, Loaded = 1
}

protocol RepositoryAccessorProtocol: class {
    func notifyRepositoryWasUpdated()
}



class RepositoryAccessor: NSObject {

    var state: AccessorState = .NotLoaded
    weak var repo: Repository!
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

    func repositoryUpdateNotification() {
        fatalError("override \(#function)")
    }

}
