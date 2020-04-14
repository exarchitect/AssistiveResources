//
//  FilterPlaybook.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/7/18.
//  Copyright © 2018 SevenPlusTwo. All rights reserved.
//

import Foundation


typealias FilterDictionary = [String: FilterElement]

protocol FilterElement {
    static var key: String { get }
    var label: String { get }
    var valueString: String { get }
    var hasValue: Bool { get }
}

protocol DescribeEnum {
    var concise: String { get }
    var verbose: String { get }
}

struct AgeFilter: FilterElement {
    var years: Int = -1
    static var key: String {
        "age"
    }
    var label: String {
        "Age"
    }
    var valueString: String {
        hasValue ? "not set" : "\(years)yo"
    }
    var hasValue: Bool {
        years <= -1
    }
}

enum Distance: Int, CaseIterable, DescribeEnum {
    case notSpecified = 0, tenMiles = 1, twentyFiveMiles = 2, fiftyMiles = 3, oneHundredMiles = 4, anyDistance = 5
    static var AllCases: [Distance] {
        return [.notSpecified, .tenMiles, .twentyFiveMiles, .fiftyMiles, .oneHundredMiles, .anyDistance]
    }
    var verbose: String {
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
    var concise: String {
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
}

struct ProximityFilter: FilterElement {
    var range: Distance = .notSpecified

    static var key: String {
        "proximity"
    }
    var label: String {
        "Proximity"
    }
    var valueString: String {
        range.concise
    }
    var hasValue: Bool {
        range != .notSpecified
    }
    static let distanceMap: [Distance: Int] = [
        .notSpecified: -1,
        .tenMiles: 10,
        .twentyFiveMiles: 25,
        .fiftyMiles: 50,
        .oneHundredMiles: 100,
        .anyDistance: 1_000_000
    ]
    var distanceValue: Int {
        ProximityFilter.distanceMap[range]!
    }
}

enum Limitation: Int, CaseIterable, DescribeEnum {
    case notSpecified = 0, noLimitation = 1, walksWithAid = 2, wheelchair = 3
    static var AllCases: [Limitation] {
        return [.notSpecified, .noLimitation, .walksWithAid, .wheelchair]
    }
    var verbose: String {
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
    var concise: String {
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
}
struct MobilityFilter: FilterElement {
    var mobilityLimit: Limitation = .notSpecified
    static var key: String {
        "mobility"
    }
    var label: String {
        "Mobility"
    }
    var valueString: String {
        mobilityLimit.concise
    }
    var hasValue: Bool {
        self.mobilityLimit != .notSpecified
    }
}

enum DevelopmentalStage: Int, CaseIterable, DescribeEnum {
    case notSpecified = 0, infant = 1, toddler = 2, preschool = 3, gradeschool = 4, preTeen = 5, teen = 6, adult = 7
    static var AllCases: [DevelopmentalStage] {
        return [.notSpecified, .infant, .toddler, .preschool, .gradeschool, .preTeen, .teen, .adult]
    }
    var verbose: String {
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
    var concise: String {
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
}
struct DevelopmentalAgeFilter: FilterElement {
    var developmentalAge: DevelopmentalStage = .notSpecified
    static var key: String {
        "developmentalAge"
    }
    var label: String {
        "Developmental Age"
    }
    var valueString: String {
        developmentalAge.concise
    }
    var hasValue: Bool {
        self.developmentalAge != .notSpecified
    }
}

enum DevelopmentalDiagnosis: Int, CaseIterable, DescribeEnum {
    case notSpecified = 0, autism = 1, cerebralPalsy = 2, spinaBifida = 3, otherDiagnosis = 4
    static var AllCases: [DevelopmentalDiagnosis] {
        return [.notSpecified, .autism, .cerebralPalsy, .spinaBifida, .otherDiagnosis]
    }
    var verbose: String {
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
    var concise: String {
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
}

struct DiagnosisFilter: FilterElement {
    var diagnosis: DevelopmentalDiagnosis = .notSpecified
    static var key: String {
        "diagnosis"
    }
    var label: String {
        "Diagnosis"
    }
    var valueString: String {
        diagnosis.concise
    }
    var hasValue: Bool {
        diagnosis != .notSpecified
    }
}


func naturalLanguageText(filters: FilterDictionary) -> String {
    var accumulateString = "Events "
    let ageFilter: AgeFilter? = filters[AgeFilter.key] as? AgeFilter
    let proximityFilter: ProximityFilter? = filters[ProximityFilter.key] as? ProximityFilter
    let mobilityValue: MobilityFilter? = filters[MobilityFilter.key] as? MobilityFilter
    let dxFilter: DiagnosisFilter? = filters[DiagnosisFilter.key] as? DiagnosisFilter

    let haveAge = ageFilter?.hasValue ?? false
    let haveProximity = proximityFilter?.hasValue ?? false
    let haveMobility = mobilityValue?.hasValue ?? false
    let haveDx = dxFilter?.hasValue ?? false

    guard haveAge || haveProximity || haveMobility || haveDx else {
        return "Upcoming events"
    }
    if let proximity = proximityFilter?.valueString {
        accumulateString.append(proximity)
    }
    if let age = ageFilter?.valueString {
        accumulateString.append(" for ")
        accumulateString.append(age)
    }
    if let primaryDx = dxFilter?.valueString {
        if ageFilter?.valueString != nil {
            accumulateString.append(" with ")
        } else {
            accumulateString.append("for someone with ")
        }
        accumulateString.append(primaryDx)
    }
    if let mobility = mobilityValue?.valueString {
        accumulateString.append(". ")
        accumulateString.append(mobility)
        accumulateString.append(".")
    }

    return accumulateString
}

