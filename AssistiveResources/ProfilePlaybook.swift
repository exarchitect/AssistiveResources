//
//  ProfilePlaybook.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 5/31/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import Foundation



enum EntityType : Int {
    case Organization, Chapter, Event, Facility
}

// MARK:- Profile-related

struct IndividualNeedProfile {
    var mobilityLimitation: MobilityLimitation
    var developmentalAge: DevelopmentalAge
    var actualAge: Int
    var diagnoses: Diagnoses

//    var primaryDiagnosis: Diagnosis
//    var secondaryDiagnosis: Diagnosis

    init(age: Int, mobility:MobilityLimitation, delay:DevelopmentalAge, diagnoses:Diagnoses?)
    {
        self.mobilityLimitation = mobility
        self.developmentalAge = delay
        self.actualAge = age        // -1 indicates age not specified
        self.diagnoses = diagnoses ?? Diagnoses()
    }
}

struct ProvidedServicesProfile {
    var supportedMobility: [MobilityLimitation] = []
    var supportedDevelopmentalAge: [DevelopmentalAge] = []
    var actualAge: Int = -1
    var diagnosis: [Diagnosis] = []
    
    func isMatch(for: IndividualNeedProfile) -> Bool {
        
        return true
    }
}




// MARK:- Location-related

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


