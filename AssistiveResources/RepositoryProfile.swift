//
//  RepositoryProfile.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/31/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit
import RealmSwift
import Realm


struct Constants {
    static let localStoreVersion = "v1.0.0.0"
    static let noSectionOpen:Int = -1
    static let noSelection:Int = -1
}

class RepositoryProfile: Object {
    
    dynamic var lastUpdated: Date = Date()
    dynamic var location: String = "00000"
    dynamic var dbVersion: String = Constants.localStoreVersion
    dynamic var haveRecords: Bool = false
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
}

