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
    func enumRawValue() -> Int?
    func itemCount() -> Int
    mutating func toggleSelection(rawValue: Int)
    func isValueSelected(rawValue: Int) -> Bool
}

extension FilterElement {
    func isValueSelected(rawValue: Int) -> Bool {
        guard let raw = enumRawValue() else {
            return false
        }
        return rawValue == raw
    }
    mutating func toggleSelection(rawValue: Int) {
        return      // func unused
    }
    func enumRawValue() -> Int? {
        return nil  // func unused
    }
}

protocol DescribableEnum {
    var concise: String { get }
    var verbose: String { get }
}

struct AgeFilter: FilterElement {
    var monthOfBirth: Int?
    var yearOfBirth: Int?
    var age: Int {
        guard let month = monthOfBirth, let year = yearOfBirth else {
            return 0
        }
        return ageSince(monthOfBirth: month, yearOfBirth: year)
    }
    private var approximateDOB: Date? {
        guard let month = monthOfBirth, let year = yearOfBirth else {
            return nil
        }
        return dobUsing(monthOfBirth: month, yearOfBirth: year)
    }

    static var key: String {
        "age"
    }
    var label: String {
        "Age"
    }
    var subtitleString: String {
        guard let year = yearOfBirth, let dobApproximate = approximateDOB else {
            return "not specified"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: dobApproximate)
        return "Born \(nameOfMonth), \(year)"
    }
    var valueString: String {
        guard hasValue == true, let monthsMatch = approximateDOB?.matchesCurrentMonth() else {
            return "not set"
        }
        return monthsMatch ? "\(age) years old this month" : "\(age) years old"
    }
    var hasValue: Bool {
        guard monthOfBirth != nil, yearOfBirth != nil else {
            return false
        }
        return true
    }
    func itemCount() -> Int {
        1
    }
    mutating func setDOB(month: Int, year: Int) {
        monthOfBirth = month
        yearOfBirth = year
    }
}

enum Distance: Int, CaseIterable, DescribableEnum {
    case tenMiles = 0, twentyFiveMiles, fiftyMiles, oneHundredMiles, anyDistance
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
    static let distanceMap: [Distance: Int] = [
        .tenMiles: 10,
        .twentyFiveMiles: 25,
        .fiftyMiles: 50,
        .oneHundredMiles: 100,
        .anyDistance: 1_000_000
    ]
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
        guard let proximity = range else {
            return "not specified"
        }
        return proximity.verbose
    }
    var hasValue: Bool {
        range != .none
    }
    func enumRawValue() -> Int? {
        guard let raw = range?.rawValue else {
            return nil
        }
        return raw
    }
    func itemCount() -> Int {
        Distance.allCases.count
    }
    var distanceValue: Int {
        guard let index = range else {
            return 0
        }
        return Distance.distanceMap[index]!
    }
    mutating func toggleSelection(rawValue: Int) {
        let newrange = Distance(rawValue: rawValue)
        if newrange == range {
            range = .none
        } else {
            range = newrange
        }
    }
}

enum Limitation: Int, CaseIterable, DescribableEnum {
    case noLimitation = 0, walksWithAid, wheelchair
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
        return limit.verbose
    }
    var hasValue: Bool {
        mobilityLimit != .none
    }
    func enumRawValue() -> Int? {
        guard let raw = mobilityLimit?.rawValue else {
            return nil
        }
        return raw
    }
    func itemCount() -> Int {
        Limitation.allCases.count
    }
    mutating func toggleSelection(rawValue: Int) {
        let newmobilityLimit = Limitation(rawValue: rawValue)
        if newmobilityLimit == mobilityLimit {
            mobilityLimit = .none
        } else {
            mobilityLimit = newmobilityLimit
        }
    }
}

enum DevelopmentalStage: Int, CaseIterable, DescribableEnum {
    case infant = 0, toddler, preschool, gradeschool, preTeen, teen, adult
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
        return stage.verbose
    }
    var hasValue: Bool {
        developmentalAge != .none
    }
    func enumRawValue() -> Int? {
        guard let raw = developmentalAge?.rawValue else {
            return nil
        }
        return raw
    }
    func itemCount() -> Int {
        DevelopmentalStage.allCases.count
    }
    mutating func toggleSelection(rawValue: Int) {
        let newdevelopmentalAge = DevelopmentalStage(rawValue: rawValue)
        if newdevelopmentalAge == developmentalAge {
            developmentalAge = .none
        } else {
            developmentalAge = newdevelopmentalAge
        }
    }
}

enum DevelopmentalDiagnosis: Int, CaseIterable, DescribableEnum {
    case autism = 0, cerebralPalsy, spinaBifida, otherDiagnosis
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
    var diagnoses: [DevelopmentalDiagnosis] = []
    static var key: String {
        "diagnosis"
    }
    var label: String {
        "Diagnosis"
    }
    var valueString: String {
        guard diagnoses.count > 0 else {
            return "not specified"
        }
        var stringArray = [String]()
        diagnoses.forEach { stringArray.append($0.concise) }
        return stringArray.joined(separator: ", ")
    }
    var hasValue: Bool {
        diagnoses.isEmpty == false
    }

    init(diagnoses: [DevelopmentalDiagnosis]) {
        self.diagnoses = diagnoses
    }
    func itemCount() -> Int {
        DevelopmentalDiagnosis.allCases.count
    }
    mutating func toggleSelection(rawValue: Int) {
        guard let newDiagnosis = DevelopmentalDiagnosis(rawValue: rawValue) else {
            return
        }
        if diagnoses.contains(newDiagnosis) {
            diagnoses.removeAll { $0 == newDiagnosis }
        } else {
            diagnoses.append(newDiagnosis)
        }
    }
    func isValueSelected(rawValue: Int) -> Bool {
        guard let newDiagnosis = DevelopmentalDiagnosis(rawValue: rawValue) else {
            return false
        }
        return diagnoses.contains(newDiagnosis)
    }
}
