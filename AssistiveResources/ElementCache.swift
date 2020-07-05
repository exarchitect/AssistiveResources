//
//  ElementCache.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 5/21/20.
//  Copyright © 2020 SevenPlusTwo. All rights reserved.
//

import UIKit
//import RealmSwift


typealias Cacheable = Identifiable

enum CacheState {
    case notLoaded, loaded      // TODO: need .loading state
}

protocol ElementCache {
    associatedtype DataType: Cacheable
    var repository: Repository? { get set }
    var cachedElements: [DataType]? { get set }
    var cacheState: CacheState { get }
    subscript(pos: Int) -> DataType? { get }
    func loadCache(using filter: FilterDictionary)
    func element(matching identifier: Int) -> DataType?
    mutating func add(_ element: DataType)
}

extension ElementCache {
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
