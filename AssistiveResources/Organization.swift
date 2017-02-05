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
    case SingleLocation = 0, MainOfficeWithChapters = 1, DistributedChapters = 2
}


enum GeographicScope : Int {
    case None = 0, International = 1, National = 2, Regional = 3, Local = 4
}



protocol OrganizationSearchProtocol {
    func matchOrganizationID (cityName: String, regionName: String, postalCode: String, countryCode: ISOCountryCode) -> Int     // regionName=State in US
}


class Chapter {
    
    // for backendless
    var objectId: String?
    var created: NSDate?
    var updated: NSDate?
    
    var chapter: EntityDescriptor = EntityDescriptor("",0)
    var parentOrganization: EntityDescriptor = EntityDescriptor("",0)
    var location: LocationProfile = LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: "")
    
    init(chapter:EntityDescriptor, parentOrganization:EntityDescriptor, location:LocationProfile) {
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
    dynamic var objectId: String?
    dynamic var created: NSDate?
    dynamic var updated: NSDate?
    
    dynamic var organizationTitle: String = ""
    dynamic var organizationID: Int = 0
    dynamic var hqLongitude: Double = 0.0
    dynamic var hqLatitude: Double = 0.0
    dynamic var hqZip: String = ""
    
    dynamic var tagline: String = ""
    dynamic var mission: String = ""
    dynamic var geographicScope: String = ""
    dynamic var website: String = ""
    
    dynamic var countryCodeISO: String = "USA"     // default

    dynamic var proximityInMiles: Double = 0.0
    
    //var dummy: Double = 0.0
    
//    var chapterList:[Chapter] = []
//    var serviceList:[Service] = []

    convenience required init(entity:EntityDescriptor, tagline:String, mission:String, scope:String, location:LocationProfile, url:String) {
        self.init()
        
        self.organizationTitle = entity.entityName
        self.organizationID = 0
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

//class Organization {
//    
//    // for backendless
//    var objectId: String?
//    var created: NSDate?
//    var updated: NSDate?
//    
//    var organization: EntityDescriptor = EntityDescriptor("",0)
//    var location: LocationProfile = LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: "")
//    
//    var organizationalStructure: OrganizationalStructure = OrganizationalStructure.MainOfficeWithChapters
//    var geographicScope: GeographicScope = GeographicScope.None
//    
//    var tagline: String = ""
//    var mission: String = ""
//    var targetPopulation: String = ""
//    var website: String = ""
//    
//    var countryCodeISO: ISOCountryCode = ISOCountryCode.USA     // default
//    
//    //    var chapterList:[Chapter] = []
//    //    var serviceList:[Service] = []
//    
//    init(entity:EntityDescriptor, tagline:String, mission:String, target:String, structure: OrganizationalStructure, scope: GeographicScope, location:LocationProfile, url:String) {
//        organization = entity
//        
//        self.location = location
//        
//        organizationalStructure = structure
//        geographicScope = scope
//        
//        self.tagline = tagline
//        self.mission = mission
//        targetPopulation = target
//        website = url
//    }
//    
//    //    func addChapter(chapter:EntityDescriptor, parentOrganization:EntityDescriptor, location:LocationProfile) {
//    //        let newchapter: Chapter = Chapter(chapter: chapter, parentOrganization: parentOrganization, location: location)
//    //        chapterList.append(newchapter)
//    //    }
//    //
//    //    func addService(title:String, descrip:String, target:String) {
//    //        let newservice: Service = Service(serviceTitle: title, serviceDescrip: descrip, serviceTarget: target)
//    //        serviceList.append(newservice)
//    //    }
//}
//
