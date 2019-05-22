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

enum FilteringElement {
    case age(years:Age)
    case proximity(mileageBand:Proximity)
    case developmentalAge(stage:DevelopmentalAge)
    case mobilityLimitation(mobility:MobilityLimitation)
    case primaryDiagnosis(primaryDx: Diagnosis)
    case secondaryDiagnosis(secondaryDx: Diagnosis)

    var hasValue: Bool {
        switch self {
        case .age(let age):
            return age.hasValue
        case .proximity(let mileageBand):
            return mileageBand.hasValue
        case .developmentalAge(let stage):
            return stage.hasValue
        case .mobilityLimitation(let mobility):
            return mobility.hasValue
        case .primaryDiagnosis(let primaryDx):
            return primaryDx.hasValue
        case .secondaryDiagnosis(let secondaryDx):
            return secondaryDx.hasValue
        }
    }
    var title: String {
        switch self {
        case .age:
            return "Age"
        case .proximity:
            return "Proximity"
        case .developmentalAge:
            return "Developmental Age"
        case .mobilityLimitation:
            return "Mobility"
        case .primaryDiagnosis:
            return "Primary Diagnosis"
        case .secondaryDiagnosis:
            return "Secondary Diagnosis"
        }
    }
}

struct FilterProfile {
    
    var ageValue:Age = .notSpecified
    var proximityValue:Proximity = .notSpecified
    var mobilityValue:MobilityLimitation = .notSpecified
    var developmentalAgeValue:DevelopmentalAge = .notSpecified
    var primaryDxValue:Diagnosis = .notSpecified
    var secondaryDxValue:Diagnosis = .notSpecified

    func naturalLanguageText() -> String {
        var accumulateString = "Events "
        let haveAtLeast1dx = primaryDxValue.hasValue || secondaryDxValue.hasValue

        guard proximityValue.hasValue || ageValue.hasValue || haveAtLeast1dx || mobilityValue.hasValue else {
            return "Upcoming events"
        }
        if proximityValue.hasValue { accumulateString.append(proximityValue.conciseValue) }
        if ageValue.hasValue {
            accumulateString.append(" for ")
            accumulateString.append(ageValue.conciseValue)
        }
        if haveAtLeast1dx && primaryDxValue != .otherDiagnosis {
            if !ageValue.hasValue { accumulateString.append("for someone") }
            accumulateString.append(" with ")
            accumulateString.append(primaryDxValue.conciseValue)
            if secondaryDxValue.hasValue && secondaryDxValue != .otherDiagnosis {
                accumulateString.append(" & ")
                accumulateString.append(secondaryDxValue.conciseValue)
            }
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
    static let verboseMap: [Proximity: String] = [
        .notSpecified: "No Distance Specified",
        .tenMiles: "Within 10 Miles",
        .twentyFiveMiles: "Within 25 Miles",
        .fiftyMiles: "Within 50 Miles",
        .oneHundredMiles: "Within 100 Miles",
        .anyDistance: "Any Distance"
    ]
    var verboseValue: String {
        return Proximity.verboseMap[self]!
    }
    static let conciseMap: [Proximity: String] = [
        .notSpecified: "None",
        .tenMiles: "within 10 mi",
        .twentyFiveMiles: "within 25 mi",
        .fiftyMiles: "within 50 mi",
        .oneHundredMiles: "within 100 mi",
        .anyDistance: "at any distance"
    ]
    var conciseValue: String {
        return Proximity.conciseMap[self]!
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
    static let verboseMap: [MobilityLimitation: String] = [
        .notSpecified: "No Limitation Specified",
        .noLimitation: "No Limitation",
        .walksWithAid: "Walks With Aid",
        .wheelchair: "Uses A Wheelchair"
    ]
    var verboseValue: String {
        return MobilityLimitation.verboseMap[self]!
    }
    static let conciseMap: [MobilityLimitation: String] = [
        .notSpecified: "None",
        .noLimitation: "No mobility limits",
        .walksWithAid: "Walks with aid",
        .wheelchair: "Uses a wheelchair"
    ]
    var conciseValue: String {
        return MobilityLimitation.conciseMap[self]!
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
    static let verboseMap: [DevelopmentalAge: String] = [
        .notSpecified: "No Developmental Age Specified",
        .infant: "Infant(1 year old)",
        .toddler: "Toddler (2 year old)",
        .preschool: "Preschool (3-5)",
        .gradeschool: "Gradeschool (6-9)",
        .preTeen: "PreTeen (10-12)",
        .teen: "Teen (13-19)",
        .adult: "Adult (20+)"
    ]
    var verboseValue: String {
        return DevelopmentalAge.verboseMap[self]!
    }
    static let conciseMap: [DevelopmentalAge: String] = [
        .notSpecified: "None",
        .infant: "infant",
        .toddler: "toddler",
        .preschool: "preschool",
        .gradeschool: "gradeschool",
        .preTeen: "preteen",
        .teen: "teen",
        .adult: "adult"
    ]
    var conciseValue: String {
        return DevelopmentalAge.conciseMap[self]!
    }
    var hasValue: Bool {
        return self != .notSpecified
    }
}

enum Diagnosis: Int, CaseIterable, Filterable {
    static var allCases: [Diagnosis] {
        return [.notSpecified, .autism, .cerebralPalsy, .spinaBifida, .otherDiagnosis]
    }
    case notSpecified=0, autism=1, cerebralPalsy=2, spinaBifida=3, otherDiagnosis=4

    static let verboseMap: [Diagnosis: String] = [
        .notSpecified: "No Diagnosis Specified",
        .autism: "Autism",
        .cerebralPalsy: "Cerebral Palsy",
        .spinaBifida: "Spina Bifida",
        .otherDiagnosis: "Other Diagnosis"
    ]
    var verboseValue: String {
        return Diagnosis.verboseMap[self]!
    }
    static let conciseMap: [Diagnosis: String] = [
        .notSpecified: "None",
        .autism: "Autism",
        .cerebralPalsy: "CP",
        .spinaBifida: "Spina Bifida",
        .otherDiagnosis: "Other Diagnosis"
    ]
    var conciseValue: String {
        return Diagnosis.conciseMap[self]!
    }
    var hasValue: Bool {
        return self != .notSpecified
    }
}

// MARK: Handling/Displaying Filters -

class ElementInteractor {
    var element: FilteringElement
    var editableRowCount = 0
    var sectionEnabled: Bool = true
    var rowsVisible: Bool = false
    public private(set) var selectionIndex: Int

    init(using filterElement: FilteringElement) {
        element = filterElement

        switch filterElement {
        case .age:
            self.editableRowCount = 1
            self.selectionIndex = 1
        case .proximity(mileageBand: let mileage):
            self.editableRowCount = Proximity.allCases.count - 1
            self.selectionIndex = mileage.rawValue
        case .developmentalAge(stage: let devStage):
            self.editableRowCount = DevelopmentalAge.allCases.count - 1
            self.selectionIndex = devStage.rawValue
        case .mobilityLimitation(mobility: let mobilityLimit):
            self.editableRowCount = MobilityLimitation.allCases.count - 1
            self.selectionIndex = mobilityLimit.rawValue
        case .primaryDiagnosis(primaryDx: let dx):
            self.editableRowCount = Diagnosis.allCases.count - 1
            self.selectionIndex = dx.rawValue
        case .secondaryDiagnosis(secondaryDx: let dx):
            self.editableRowCount = Diagnosis.allCases.count - 1
            self.selectionIndex = dx.rawValue
        }
    }

    func select(at index: Int) {
        self.selectionIndex = index
        switch self.element {
        case .age:
            self.element = .age(years: Age(years: 1))
        case .proximity:
            self.element = .proximity(mileageBand: Proximity(rawValue: index)!)
        case .developmentalAge:
            self.element = .developmentalAge(stage: DevelopmentalAge(rawValue: index)!)
        case .mobilityLimitation:
            self.element = .mobilityLimitation(mobility: MobilityLimitation(rawValue: index)!)
        case .primaryDiagnosis:
            self.element = .primaryDiagnosis(primaryDx: Diagnosis(rawValue: index)!)
        case .secondaryDiagnosis:
            self.element = .secondaryDiagnosis(secondaryDx: Diagnosis(rawValue: index)!)
        }
    }

    func label(at index:Int) -> String {
        var returnString:String!
        switch self.element {
        case .age(let age):
            returnString = age.verboseValue
        case .proximity:
            returnString = Proximity.allCases[index].verboseValue
        case .developmentalAge:
            returnString = DevelopmentalAge.allCases[index].verboseValue
        case .mobilityLimitation:
            returnString = MobilityLimitation.allCases[index].verboseValue
        case .primaryDiagnosis:
            returnString = Diagnosis.allCases[index].verboseValue
        case .secondaryDiagnosis:
            returnString = Diagnosis.allCases[index].verboseValue
        }
        return returnString
    }

}

class FilterInputTemplate: NSObject {

    private var elements:[ElementInteractor] = []

    var count: Int {
        return elements.count
    }

    subscript(pos: Int) -> ElementInteractor {
        return elements[pos]
    }

    func add(filter: ElementInteractor) {
        elements.append(filter)
    }

    func createProfile() -> FilterProfile {
        var returnData = FilterProfile()

        for element in elements {
            switch element.element {
            case .age(years: let yrs):
                returnData.ageValue = yrs
            case .proximity(mileageBand: let mileage):
                returnData.proximityValue = mileage
            case .developmentalAge(stage: let devStage):
                returnData.developmentalAgeValue = devStage
            case .mobilityLimitation(mobility: let mobilityLimit):
                returnData.mobilityValue = mobilityLimit
            case .primaryDiagnosis(primaryDx: let dx):
                returnData.primaryDxValue = dx
            case .secondaryDiagnosis(secondaryDx: let dx):
                returnData.secondaryDxValue = dx
            }
        }
        return returnData
    }
}

