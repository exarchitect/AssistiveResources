//
//  ProfilePlaybook.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 5/31/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import Foundation


enum MobilityLimitation : Int {
    case NoLimitation, AnyLimitation, WalkingWithBrace, WalkingWithCane, Wheelchair, Bedridden
}

enum DevelopmentalDelay : Int {
    case NoDelay, AnyDelay, XDelay, YDelay, ZDelay
}

enum Diagnosis : Int {
    case NoDiagnosis, AnyDiagnosis, AutismDiagnosis, CPDiagnosis, SpinaBifidaDiagnosis, XDiagnosis, YDiagnosis, ZDiagnosis
}

enum EntityType : Int {
    case Organization, Chapter, Event, Facility
}


struct NeedsProfile {
    var mobilityLimitation: MobilityLimitation
    var developmentalDelay: DevelopmentalDelay
    var diagnosis: Diagnosis
    
    init(mobility:MobilityLimitation, delay:DevelopmentalDelay, dx:Diagnosis)
    {
        mobilityLimitation = mobility
        developmentalDelay = delay
        diagnosis = dx
    }
}


enum ISOCountryCode : String {      // only support USA initially
    case USA = "USA", GBR = "GBR"
}


struct LocationProfile {
    var coordinates: CLLocationCoordinate2D!
    var countryCode: ISOCountryCode
    var regionName: String
    var cityName: String
    var zipCode: String
    
    init(zip:String)
    {
        countryCode = ISOCountryCode.USA
        cityName = ""
        regionName = ""
        zipCode = zip
        coordinates = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }

    init(latitude:Double, longitude:Double, city:String, state:String, zip:String, country:ISOCountryCode = ISOCountryCode.USA)
    {
        countryCode = country
        cityName = city
        regionName = state
        zipCode = zip
        coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}


