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
    static let amountNotSpecified:Int = -1
}

class RepositoryProfile: Object {
    
    @objc dynamic var lastUpdated: Date = Date()
    @objc dynamic var location: String = "00000"
    @objc dynamic var dbVersion: String = Constants.localStoreVersion
    @objc dynamic var haveRecords: Bool = false
    
    required init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        fatalError("init(realm:schema:) has not been implemented")
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

