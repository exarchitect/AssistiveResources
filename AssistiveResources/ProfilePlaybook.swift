//
//  ProfilePlaybook.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 5/31/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import Foundation


enum MobilityLimitation : Int {
    case NoLimitationSpecified, NoLimitation, WalkWithAid, Wheelchair
}

enum DevelopmentalAge : Int {
    case NoDevelopmentalAgeSpecified, InfantDevelopmentalAge, ToddlerDevelopmentalAge, PreschoolDevelopmentalAge, GradeschoolDevelopmentalAge, PreTeenDevelopmentalAge, TeenDevelopmentalAge, AdultDevelopmentalAge
    // infant 1, toddler 2, preschool 3-5, gradeschool 6-9, pre-teen 10-12, teen 13-19, adult 20+
}

enum Diagnosis : Int {
    case NoDiagnosisSpecified, AutismDiagnosis, CPDiagnosis, SpinaBifidaDiagnosis, OtherDiagnosis
}

enum EntityType : Int {
    case Organization, Chapter, Event, Facility
}

struct IndividualNeedProfile {
    var mobilityLimitation: MobilityLimitation
    var developmentalAge: DevelopmentalAge
    var actualAge: Int
    var primaryDiagnosis: Diagnosis
    var secondaryDiagnosis: Diagnosis

    init(age: Int, mobility:MobilityLimitation, delay:DevelopmentalAge, primarydx:Diagnosis, secondarydx:Diagnosis)
    {
        self.mobilityLimitation = mobility
        self.developmentalAge = delay
        self.actualAge = age        // -1 indicates age not specified
        self.primaryDiagnosis = primarydx
        self.secondaryDiagnosis = secondarydx
    }
}

struct TargetNeedProfile {
    var supportedMobility: [MobilityLimitation] = []
    var supportedDevelopmentalAge: [DevelopmentalAge] = []
    var actualAge: Int = -1
    var diagnosis: [Diagnosis] = []
    
    func isMatch(for: IndividualNeedProfile) -> Bool {
        
        return true
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


