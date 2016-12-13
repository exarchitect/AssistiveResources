//
//  Organization.swift
//  SwiftNeed
//
//  Created by Bill Johnson on 5/27/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


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
    
    var chapter: EntityDescriptor = EntityDescriptor("",0,0)
    var parentOrganization: EntityDescriptor = EntityDescriptor("",0,0)
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


class Organization {
    
    // for backendless
    var objectId: String?
    var created: NSDate?
    var updated: NSDate?
    
    var organization: EntityDescriptor = EntityDescriptor("",0,0)
    var location: LocationProfile = LocationProfile(latitude: 0.0,longitude: 0.0,city: "",state: "",zip: "")
    
    var organizationalStructure: OrganizationalStructure = OrganizationalStructure.MainOfficeWithChapters
    var geographicScope: GeographicScope = GeographicScope.None

    var tagline: String = ""
    var mission: String = ""
    var targetPopulation: String = ""
    var website: String = ""
    
    var countryCodeISO: ISOCountryCode = ISOCountryCode.USA     // default

//    var chapterList:[Chapter] = []
//    var serviceList:[Service] = []

    init(entity:EntityDescriptor, tagline:String, mission:String, target:String, structure: OrganizationalStructure, scope: GeographicScope, location:LocationProfile, url:String) {
        organization = entity
        
        self.location = location
        
        organizationalStructure = structure
        geographicScope = scope
        
        self.tagline = tagline
        self.mission = mission
        targetPopulation = target
        website = url
    }
    
//    func addChapter(chapter:EntityDescriptor, parentOrganization:EntityDescriptor, location:LocationProfile) {
//        let newchapter: Chapter = Chapter(chapter: chapter, parentOrganization: parentOrganization, location: location)
//        chapterList.append(newchapter)
//    }
//    
//    func addService(title:String, descrip:String, target:String) {
//        let newservice: Service = Service(serviceTitle: title, serviceDescrip: descrip, serviceTarget: target)
//        serviceList.append(newservice)
//    }
}

