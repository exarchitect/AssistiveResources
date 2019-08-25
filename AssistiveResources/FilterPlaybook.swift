//
//  FilterPlaybook.swift
//  AssistiveResources
//
//  Created by WCJ on 2/7/18.
//  Copyright © 2018 SevenPlusTwo. All rights reserved.
//

import Foundation


// ------------------------------------------------------------------------------
// MARK: Profile Characteristics -

protocol Filterable {
    var verboseValue: String { get }
    var conciseValue: String { get }
    var hasValue: Bool { get }
}
//extension Filterable where Self == Diagnosis {
//    var hasValue: Bool {
//        //return self.rawValue != 0
//        return self != .notSpecified
//    }
//}

struct FilterProfile {
    
    var ageValue:Age = .notSpecified
    var proximityValue:Proximity = .notSpecified
    var mobilityValue:MobilityLimitation = .notSpecified
    var developmentalAgeValue:DevelopmentalAge = .notSpecified
    var diagnoses:Diagnoses = Diagnoses()

    func naturalLanguageText() -> String {
        var accumulateString = "Events "
//        let haveAtLeast1dx = primaryDxValue.hasValue || secondaryDxValue.hasValue

        guard proximityValue.hasValue || ageValue.hasValue || diagnoses.hasValue == true || mobilityValue.hasValue else {
            return "Upcoming events"
        }
        if proximityValue.hasValue { accumulateString.append(proximityValue.conciseValue) }
        if ageValue.hasValue {
            accumulateString.append(" for ")
            accumulateString.append(ageValue.conciseValue)
        }
//        if diagnosisValue.hasValue && diagnosisValue != .otherDiagnosis {
        if diagnoses.hasValue == true {
            if !ageValue.hasValue { accumulateString.append("for someone") }
            accumulateString.append(" with ")
            accumulateString.append(diagnoses.dx[0].conciseValue)
//            if secondaryDxValue.hasValue && secondaryDxValue != .otherDiagnosis {
//                accumulateString.append(" & ")
//                accumulateString.append(secondaryDxValue.conciseValue)
//            }
        }
        if mobilityValue.hasValue {
            accumulateString.append(". ")
            accumulateString.append(mobilityValue.conciseValue)
            accumulateString.append(".")
        }
        
        return accumulateString
    }
}

// MARK: Base Enumerated Filter Types -

enum Age: Filterable {
    case notSpecified
    case age(years: Int)

    init(years: Int) {
        if years < 0 {
            self = .notSpecified
        } else {
            self = .age(years: years)
        }
    }
    var verboseValue: String {
        switch self {
        case .notSpecified:
            return "not set"
        case .age(let years):
            return "\(years) year old"
        }
    }
    var conciseValue: String {
        switch self {
        case .notSpecified:
            return "not set"
        case .age(let years):
            return "\(years)yo"
        }
    }
    var hasValue: Bool {
        switch self {
        case .notSpecified:
            return false
        case .age:
            return true
        }
    }
}

enum Proximity: Int, CaseIterable, Filterable {
    case notSpecified=0, tenMiles=1, twentyFiveMiles=2, fiftyMiles=3, oneHundredMiles=4, anyDistance=5
    static var allCases: [Proximity] {
        return [.notSpecified, .tenMiles, .twentyFiveMiles, .fiftyMiles, .oneHundredMiles, .anyDistance]
    }
    var verboseValue: String {
        switch self {
        case .notSpecified:
            return "No Distance Specified"
        case .tenMiles:
            return "Within 10 Miles"
        case .twentyFiveMiles:
            return "Within 25 Miles"
        case .fiftyMiles:
            return "Within 50 Miles"
        case .oneHundredMiles:
            return "Within 100 Miles"
        case .anyDistance:
            return "Any Distance"
        }
    }
    var conciseValue: String {
        switch self {
        case .notSpecified:
            return "not specified"
        case .tenMiles:
            return "within 10 mi"
        case .twentyFiveMiles:
            return "within 25 mi"
        case .fiftyMiles:
            return "within 50 mi"
        case .oneHundredMiles:
            return "within 100 mi"
        case .anyDistance:
            return "at any distance"
        }
    }
    static let distanceMap: [Proximity: Int] = [
        .notSpecified: -1,
        .tenMiles: 10,
        .twentyFiveMiles: 25,
        .fiftyMiles: 50,
        .oneHundredMiles: 100,
        .anyDistance: 1_000_000
    ]
    var distanceValue: Int {
        return Proximity.distanceMap[self]!
    }
    var hasValue: Bool {
        return self != .notSpecified
    }
}

enum MobilityLimitation: Int, CaseIterable, Filterable {
    case notSpecified=0, noLimitation=1, walksWithAid=2, wheelchair=3
    static var allCases: [MobilityLimitation] {
        return [.notSpecified, .noLimitation, .walksWithAid, .wheelchair]
    }
    var verboseValue: String {
        switch self {
        case .notSpecified:
            return "No Limitation Specified"
        case .noLimitation:
            return "No Limitation"
        case .walksWithAid:
            return "Walks With Aid"
        case .wheelchair:
            return "Uses A Wheelchair"
        }
    }
    var conciseValue: String {
        switch self {
        case .notSpecified:
            return "not specified"
        case .noLimitation:
            return "No mobility limits"
        case .walksWithAid:
            return "Walks with aid"
        case .wheelchair:
            return "Uses wheelchair"
        }
    }
    var hasValue: Bool {
        return self != .notSpecified
    }
}

enum DevelopmentalAge: Int, CaseIterable, Filterable {
    case notSpecified=0, infant=1, toddler=2, preschool=3, gradeschool=4, preTeen=5, teen=6, adult=7
    static var allCases: [DevelopmentalAge] {
        return [.notSpecified, .infant, .toddler, .preschool, .gradeschool, .preTeen, .teen, .adult]
    }
    var verboseValue: String {
        switch self {
        case .notSpecified:
            return "No Developmental Age Specified"
        case .infant:
            return "Infant(1 year old)"
        case .toddler:
            return "Toddler (2 year old)"
        case .preschool:
            return "Preschool (3-5)"
        case .gradeschool:
            return "Gradeschool (6-9)"
        case .preTeen:
            return "PreTeen (10-12)"
        case .teen:
            return "Teen (13-19)"
        case .adult:
            return "Adult (20+)"
        }
    }
    var conciseValue: String {
        switch self {
        case .notSpecified:
            return "not specified"
        case .infant:
            return "infant"
        case .toddler:
            return "toddler"
        case .preschool:
            return "preschool"
        case .gradeschool:
            return "gradeschool"
        case .preTeen:
            return "preteen"
        case .teen:
            return "teen"
        case .adult:
            return "adult"
        }
    }
    var hasValue: Bool {
        return self.rawValue != 0
    }
}

struct Diagnoses: Filterable {
    var dx: [Diagnosis] = []
    var verboseValue: String {
        if dx.isEmpty {
            return "No Diagnosis Specified"
        } else {
            return dx[0].verboseValue
        }
    }
    var conciseValue: String {
        if dx.isEmpty {
            return "not specified"
        } else {
            return dx[0].verboseValue
        }
    }
    var hasValue: Bool {
        return dx.isEmpty == false
    }
}

enum Diagnosis: Int, CaseIterable, Filterable {
    case notSpecified=0, autism=1, cerebralPalsy=2, spinaBifida=3, otherDiagnosis=4
//    case autism=1, cerebralPalsy=2, spinaBifida=3, otherDiagnosis=4
    static var allCases: [Diagnosis] {
        return [.notSpecified, .autism, .cerebralPalsy, .spinaBifida, .otherDiagnosis]
//        return [.autism, .cerebralPalsy, .spinaBifida, .otherDiagnosis]
    }
    var verboseValue: String {
        switch self {
        case .notSpecified:
            return "No Diagnosis Specified"
        case .autism:
            return "Autism"
        case .cerebralPalsy:
            return "Cerebral Palsy"
        case .spinaBifida:
            return "Spina Bifida"
        case .otherDiagnosis:
            return "Other Diagnosis"
        }
    }
    var conciseValue: String {
        switch self {
        case .notSpecified:
            return "not specified"
        case .autism:
            return "Autism"
        case .cerebralPalsy:
            return "CP"
        case .spinaBifida:
            return "Spina Bifida"
        case .otherDiagnosis:
            return "Other Diagnosis"
        }
    }
    var hasValue: Bool {
        return true
    }
}

