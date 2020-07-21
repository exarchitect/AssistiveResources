//
//  Repository.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/8/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit


let kExpirationSeconds = 60 * 60 * 24       // 24 hours

typealias RepositoryUpdateCompletionHandlerType = (_ success: Bool) -> Void
typealias RemoteDataRetrievalCompletionType = (_ success: Bool) -> Void

enum RepositoryState {
    case current, outdated, invalidLocation, empty
}

protocol RemoteDatasource {
    func validateConnection ()
    func pull (completion: @escaping RemoteDataRetrievalCompletionType)
}

protocol LocalRepository: class {
    var available: Bool { get set }
    var dataUpdateCompletion: RepositoryUpdateCompletionHandlerType? { get set }

    func repositoryStateUpdate() -> RepositoryState
    func initiateRemoteLoading()
    func clearLocalStore()
    func repositoryUpdateNotificationKey() -> String

    func load(completion: @escaping RepositoryUpdateCompletionHandlerType)
    func checkNeedUpdate()
    func beginRepositoryUpdate()
    func endRepositoryUpdate()
}

extension LocalRepository {
    func load(completion: @escaping RepositoryUpdateCompletionHandlerType) {

        let repoStartupState = self.repositoryStateUpdate()
        dataUpdateCompletion = completion

        switch repoStartupState {

        case .current:
            available = true
            completion(true)
            dataUpdateCompletion = nil

        case .outdated:     // handled on background update
            available = true
            completion(true)
            dataUpdateCompletion = nil

        case .invalidLocation:
            initiateRemoteLoading()

        case .empty:
            initiateRemoteLoading()
        }
    }

    func checkNeedUpdate() {
        let repoState = repositoryStateUpdate()

        switch repoState {
        case .current:
            break
        case .outdated, .invalidLocation, .empty:
            initiateRemoteLoading()
        }
    }

    func beginRepositoryUpdate() {
        available = false
    }

    func endRepositoryUpdate() {
        available = true

        let notificationkey = self.repositoryUpdateNotificationKey()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationkey), object: nil)
    }
}
