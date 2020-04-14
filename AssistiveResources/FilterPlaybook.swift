//
//  FilterPlaybook.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/7/18.
//  Copyright © 2018 SevenPlusTwo. All rights reserved.
//

import Foundation


typealias FilterDictionary = [String: FilterElement]

let invalidRawValue = -1

protocol FilterElement {
    static var key: String { get }
    var label: String { get }
    var valueString: String { get }
    var hasValue: Bool { get }
    func enumRawValue() -> Int
    func valueCount() -> Int
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
    func enumRawValue() -> Int {
        1
    }
    func valueCount() -> Int {
        1
    }
}

enum Distance: Int, CaseIterable, DescribeEnum {
    case tenMiles = 0, twentyFiveMiles, fiftyMiles, oneHundredMiles, anyDistance
    static var AllCases: [Distance] {
        return [.tenMiles, .twentyFiveMiles, .fiftyMiles, .oneHundredMiles, .anyDistance]
    }
    var verbose: String {
        switch self {
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
    var range: Distance? = .none

    static var key: String {
        "proximity"
    }
    var label: String {
        "Proximity"
    }
    var valueString: String {
        range?.concise ?? ""
    }
    var hasValue: Bool {
        range != .none
    }
    func enumRawValue() -> Int {
        range?.rawValue ?? invalidRawValue
    }
    func valueCount() -> Int {
        Distance.allCases.count
    }
    static let distanceMap: [Distance: Int] = [
        .tenMiles: 10,
        .twentyFiveMiles: 25,
        .fiftyMiles: 50,
        .oneHundredMiles: 100,
        .anyDistance: 1_000_000
    ]
    var distanceValue: Int {
        guard let index = range else {
            return -1
        }
        return ProximityFilter.distanceMap[index]!
    }
}

enum Limitation: Int, CaseIterable, DescribeEnum {
    case noLimitation = 0, walksWithAid, wheelchair
    static var AllCases: [Limitation] {
        return [.noLimitation, .walksWithAid, .wheelchair]
    }
    var verbose: String {
        switch self {
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
    var mobilityLimit: Limitation? = .none
    static var key: String {
        "mobility"
    }
    var label: String {
        "Mobility"
    }
    var valueString: String {
        guard let limit = mobilityLimit else {
            return "not specified"
        }
        return limit.concise
    }
    var hasValue: Bool {
        mobilityLimit != .none
    }
    func enumRawValue() -> Int {
        mobilityLimit?.rawValue ?? invalidRawValue
    }
    func valueCount() -> Int {
        Limitation.allCases.count
    }
}

enum DevelopmentalStage: Int, CaseIterable, DescribeEnum {
    case infant = 0, toddler, preschool, gradeschool, preTeen, teen, adult
    static var AllCases: [DevelopmentalStage] {
        return [.infant, .toddler, .preschool, .gradeschool, .preTeen, .teen, .adult]
    }
    var verbose: String {
        switch self {
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
    var developmentalAge: DevelopmentalStage? = .none
    static var key: String {
        "developmentalAge"
    }
    var label: String {
        "Developmental Age"
    }
    var valueString: String {
        guard let stage = developmentalAge else {
            return "not specified"
        }
        return stage.concise
    }
    var hasValue: Bool {
        developmentalAge != .none
    }
    func enumRawValue() -> Int {
        developmentalAge?.rawValue ?? invalidRawValue
    }
    func valueCount() -> Int {
        DevelopmentalStage.allCases.count
    }
}

enum DevelopmentalDiagnosis: Int, CaseIterable, DescribeEnum {
    case autism = 0, cerebralPalsy, spinaBifida, otherDiagnosis
    static var AllCases: [DevelopmentalDiagnosis] {
        return [.autism, .cerebralPalsy, .spinaBifida, .otherDiagnosis]
    }
    var verbose: String {
           switch self {
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
    var diagnosis: DevelopmentalDiagnosis? = .none
    static var key: String {
        "diagnosis"
    }
    var label: String {
        "Diagnosis"
    }
    var valueString: String {
        guard let diagnose = diagnosis else {
            return "not specified"
        }
        return diagnose.concise
    }
    var hasValue: Bool {
        diagnosis != .none
    }
    func enumRawValue() -> Int {
        diagnosis?.rawValue ?? invalidRawValue
    }
    func valueCount() -> Int {
        DevelopmentalDiagnosis.allCases.count
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

