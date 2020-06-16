//
//  ElementCache.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 5/21/20.
//  Copyright © 2020 SevenPlusTwo. All rights reserved.
//

import UIKit
import RealmSwift


typealias Cacheable = Identifiable

protocol RepositoryCache {
    associatedtype DataType: Cacheable
    var repository: Repository? { get set }
    var cachedElements: [DataType]? { get set }
    var cacheState: CacheState { get }
    subscript(pos: Int) -> DataType? { get }
    func loadCache(using filter: FilterDictionary)
    func element(matching identifier: Int) -> DataType?
//    func repositoryUpdateNotification()
    mutating func add(_ element: DataType)
}

extension RepositoryCache {
    var count: Int {
        cachedElements?.count ?? 0
    }
    var cacheState: CacheState {
        guard let repo = repository, repo.available == true else {
            return .notLoaded
        }
        return .loaded
    }
    subscript(pos: Int) -> DataType? {
        cachedElements?[pos]
    }
    func element(matching identifier: Int) -> DataType? {
        cachedElements?.first { $0.identifier == identifier }
    }
    mutating func add(_ element: DataType) {
        cachedElements?.append(element)
    }
}

//class ElementCache<T: Object, CacheManager> {
//
//    private var cachedElements: [T]?
//
////    func repositoryUpdateNotification() {
////        let needProfile = FilterDictionary()
////        updateLocalCache(using: needProfile)
////        delegate?.notifyRepositoryWasUpdated()
////    }
//
//    func reloadCache(using filter: FilterDictionary) {
//
//        cachedElements = []
//        do {
//            let realm = try Realm()
//            let events = realm.objects(T.self)
//            for event in events {
//                add(event)
//            }
//
//        } catch let error as NSError {
//            // handle error
//
//            let _ = error
//        }
//
//    }
//
//    private func add(_ element: T) {
//        guard cachedElements != nil else {
//            return
//        }
//        cachedElements!.append(element)
//    }
//}
