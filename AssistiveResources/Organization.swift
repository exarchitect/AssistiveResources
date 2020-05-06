//
//  Organization.swift
//  SwiftNeed
//
//  Created by Bill Johnson on 5/27/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit
import RealmSwift


enum OrganizationalStructure : Int {
    case singleLocation = 0, mainOfficeWithChapters = 1, distributedChapters = 2
}

enum GeographicScope : Int {
    case all = 0, global = 1, national = 2, regional = 3, local = 4
}

protocol OrganizationSearchProtocol {
    func matchOrganizationID (cityName: String, regionName: String, postalCode: String, countryCode: ISOCountryCode) -> Int     // regionName=State in US
}

//struct OrganizationFilter {
//    var needProfile: TargetNeedProfile?
//    var proximityRadius: Int = -1
//    let entityType: EntityType = .Organization      // read-only
//    var entityDescriptor: EntityDescriptor
//}

class Chapter {
    
    // for backendless
    var objectId: String?
    var created: NSDate?
    var updated: NSDate?
    
    var chapter = ChapterDescriptor(name: "", identifier: 0)
    var parentOrganization = OrganizationDescriptor(name: "", identifier: 0)
    var location = LocationProfile(latitude: 0.0, longitude: 0.0, city: "", state: "", zip: "")
    
    init(chapter:ChapterDescriptor, parentOrganization:OrganizationDescriptor, location:LocationProfile) {
        self.chapter = chapter
        self.parentOrganization = parentOrganization
        self.location = location
    }
}


class Service {
    
    // for backendless
    var objectId: String?
    var created: NSDate?
    var updated: NSDate?
    
    var serviceTitle: String = ""
    var serviceDescription: String = ""
    var targetPopulation: String = ""

    init(serviceTitle:String, serviceDescrip:String, serviceTarget:String) {
        self.serviceTitle = serviceTitle
        self.serviceDescription = serviceDescrip
        self.targetPopulation = serviceTarget
    }
}


class Organization: Object {
    
    // for backendless
    @objc dynamic var objectId: String?
    @objc dynamic var created: NSDate?
    @objc dynamic var updated: NSDate?
    
    @objc dynamic var organizationTitle: String = ""
    @objc dynamic var organizationID: Int = 0
    @objc dynamic var hqLongitude: Double = 0.0
    @objc dynamic var hqLatitude: Double = 0.0
    @objc dynamic var hqZip: String = ""
    
    @objc dynamic var tagline: String = ""
    @objc dynamic var mission: String = ""
    @objc dynamic var geographicScope: String = ""
    @objc dynamic var website: String = ""
    
    @objc dynamic var countryCodeISO: String = "USA"     // default

    @objc dynamic var proximityInMiles: Double = 0.0
    
    var descriptor: OrganizationDescriptor {
        OrganizationDescriptor(name: organizationTitle, identifier: organizationID)
    }

    //var dummy: Double = 0.0
    
//    var chapterList:[Chapter] = []
//    var serviceList:[Service] = []

    convenience required init(entity:OrganizationDescriptor, tagline:String, mission:String, scope:String, location:LocationProfile, url:String) {
        self.init()
        
        self.organizationTitle = entity.name
        self.organizationID = entity.identifier
        self.hqLatitude = location.coordinates.latitude
        self.hqLongitude = location.coordinates.longitude
        self.hqZip = ""
        
        self.tagline = tagline
        self.mission = mission
        self.geographicScope = scope
        self.website = url
    }
    
    //Specify properties to ignore (Realm won't persist)
    
//    override static func ignoredProperties() -> [String] {
//        return ["dummy"]
//    }
    
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

