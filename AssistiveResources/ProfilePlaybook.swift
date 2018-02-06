//
//  ProfilePlaybook.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 5/31/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import Foundation


protocol CaseCountable {
    static var caseCount: Int { get }
}

extension CaseCountable where Self: RawRepresentable, Self.RawValue == Int {
    internal static var caseCount: Int {
        var count = 0
        while let _ = Self(rawValue: count) {
            count += 1
        }
        return count
    }
}


// MARK: Profile Characteristics -

enum ProximityToService : Int, CaseCountable {
    case NoProximitySpecified, TenMiles, TwentyFiveMiles, FiftyMiles, OneHundredMiles, AnyDistance
    
    static let titleAtIndex = ["No Distance Specified", "Within 10 Miles", "Within 25 Miles", "Within 50 Miles", "Within 100 Miles", "Any Distance"]
}

enum MobilityLimitation : Int, CaseCountable {
    case NoLimitationSpecified, NoLimitation, WalkWithAid, Wheelchair

    static let titleAtIndex = ["No Limitation Specified", "No Limitation", "Walk With Aid", "Wheelchair"]
}

enum DevelopmentalAge : Int, CaseCountable {
    case NoDevelopmentalAgeSpecified, InfantDevelopmentalAge, ToddlerDevelopmentalAge, PreschoolDevelopmentalAge, GradeschoolDevelopmentalAge, PreTeenDevelopmentalAge, TeenDevelopmentalAge, AdultDevelopmentalAge
    // infant 1, toddler 2, preschool 3-5, gradeschool 6-9, pre-teen 10-12, teen 13-19, adult 20+

    static let titleAtIndex = ["No Developmental Age Specified", "Infant", "Toddler", "Preschool", "Gradeschool", "PreTeen", "Teen", "Adult"]
}

enum Diagnosis : Int, CaseCountable {
    case NoDiagnosisSpecified, AutismDiagnosis, CPDiagnosis, SpinaBifidaDiagnosis, OtherDiagnosis

    static let titleAtIndex = ["No Diagnosis Specified", "Autism", "CP", "Spina Bifida", "Other Diagnosis"]
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

struct ProvidedServicesProfile {
    var supportedMobility: [MobilityLimitation] = []
    var supportedDevelopmentalAge: [DevelopmentalAge] = []
    var actualAge: Int = -1
    var diagnosis: [Diagnosis] = []
    
    func isMatch(for: IndividualNeedProfile) -> Bool {
        
        return true
    }
}




// MARK: Location-related -

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


