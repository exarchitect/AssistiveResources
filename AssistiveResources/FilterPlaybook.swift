//
//  FilterPlaybook.swift
//  AssistiveResources
//
//  Created by WCJ on 2/7/18.
//  Copyright © 2018 SevenPlusTwo. All rights reserved.
//

import Foundation


// ------------------------------------------------------------------------------
// MARK:- Filter configuration


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

enum RenderType {
    case titleOnly, nilValue
}
protocol Nameable {
    func render (_ renderType: RenderType) -> String
}
protocol Labelable {
    var verboseLabel: String { get }
    var conciseLabel: String { get }
}

enum FilteringElement: Nameable {
    case age(years:Int)
    case proximity(mileageBand:Proximity)
    case developmentalAge(stage:DevelopmentalAge)
    case mobilityLimitation(mobility:MobilityLimitation)
    case primaryDiagnosis(primaryDx: Diagnosis)
    case secondaryDiagnosis(secondaryDx: Diagnosis)

    func render(_ renderType: RenderType) -> String {
        switch self {
        case .age(let yrs):
            if renderType == .titleOnly { return "Age" }
            if renderType == .nilValue { return "not set" }
            if (yrs == 0 || yrs == -1) { return "not set" }
//            if renderType == .valueOnly { return String(yrs) }
//            if renderType == .abbreviatedPhrase { return "\(yrs)yo" }
//            if renderType == .fullPhrase { return "\(yrs) year old" }

        case .proximity(let mileageBand):
            if renderType == .titleOnly { return "Proximity" }
            if renderType == .nilValue { return "none selected" }
//            if renderType == .abbreviatedPhrase { return mileageBand.conciseLabel }
//            if renderType == .fullPhrase { return mileageBand.verboseLabel }

        case .developmentalAge(let stage):
            if renderType == .titleOnly { return "Developmental Age" }
            if renderType == .nilValue { return "none selected" }
//            if renderType == .abbreviatedPhrase { return stage.conciseLabel }
//            if renderType == .fullPhrase { return stage.verboseLabel }

        case .mobilityLimitation(let mobility):
            if renderType == .titleOnly { return "Mobility" }
            if renderType == .nilValue { return "none selected" }
//            if renderType == .abbreviatedPhrase { return mobility.conciseLabel }
//            if renderType == .fullPhrase { return mobility.verboseLabel }

        case .primaryDiagnosis(let primaryDx):
            if renderType == .titleOnly { return "Primary Diagnosis" }
            if renderType == .nilValue { return "none selected" }
//            if renderType == .abbreviatedPhrase { return primaryDx.conciseLabel }
//            if renderType == .fullPhrase { return primaryDx.verboseLabel }

        case .secondaryDiagnosis(let secondaryDx):
            if renderType == .titleOnly { return "Secondary Diagnosis" }
            if renderType == .nilValue { return "none selected" }
//            if renderType == .abbreviatedPhrase { return secondaryDx.conciseLabel }
//            if renderType == .fullPhrase { return secondaryDx.verboseLabel }
        }
        return ""
    }
}

class ElementInteractor {

    var element: FilteringElement
    var editableRowCount = 0
    var sectionEnabled: Bool = true
    var rowsVisible: Bool = false
    public private(set) var selectionIndex: Int
    var haveValue: Bool {
        get {
            return selectionIndex != Constants.noSelection
        }
    }

    init(using filterElement: FilteringElement) {
        element = filterElement
        
        switch filterElement {
        case .age(years: let yrs):
            self.editableRowCount = 1
            self.selectionIndex = yrs
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

    func render(_ renderType: RenderType) -> String {
        return element.render(renderType)
    }

    func select(at index: Int) {
        self.selectionIndex = index
        switch self.element {
        case .age:
            self.element = .age(years: index)
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
    
    func label(atIndex:Int) -> String {
        var returnString:String!
        switch self.element {
        case .age(years: let yrs):
            let txt = "\(yrs)yo"
            returnString = txt
        case .proximity:
            returnString = Proximity.allCases[atIndex].verboseLabel
        case .developmentalAge:
            returnString = DevelopmentalAge.allCases[atIndex].verboseLabel
        case .mobilityLimitation:
            returnString = MobilityLimitation.allCases[atIndex].verboseLabel
        case .primaryDiagnosis:
            returnString = Diagnosis.allCases[atIndex].verboseLabel
        case .secondaryDiagnosis:
            returnString = Diagnosis.allCases[atIndex].verboseLabel
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
    
    func createValues() -> FilterValues {
        var returnData = FilterValues()
        
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

struct FilterValues {
    
    var ageValue:Int = Constants.amountNotSpecified
    var proximityValue:Proximity = .notSpecified
    var mobilityValue:MobilityLimitation = .notSpecified
    var developmentalAgeValue:DevelopmentalAge = .notSpecified
    var primaryDxValue:Diagnosis = .notSpecified
    var secondaryDxValue:Diagnosis = .notSpecified

    func naturalLanguageText() -> String {
        var accumulateString = "Events "
        
        let haveproximity = proximityValue != .notSpecified
        let haveAge = ageValue > -1
        let haveDevAge = developmentalAgeValue != .notSpecified
        let haveAtLeast1dx = primaryDxValue != .notSpecified && primaryDxValue != .otherDiagnosis
        let havemobility = mobilityValue != .notSpecified

        guard haveproximity || haveAge || haveDevAge || haveAtLeast1dx || havemobility else {
            return "Upcoming events"
        }
        if haveproximity { accumulateString.append(proximityValue.conciseLabel) }
        if haveAge {
            accumulateString.append(" for ")
            if haveAge {
                accumulateString.append("\(ageValue)yo")
                //if haveDevAge { accumulateString.append(" ") }
            }
        }
        if haveAtLeast1dx {
            if !haveAge { accumulateString.append("for someone") }
            accumulateString.append(" with ")
            accumulateString.append(primaryDxValue.conciseLabel)
        }
        if secondaryDxValue != .notSpecified && secondaryDxValue != .otherDiagnosis {
            accumulateString.append(" & ")
            accumulateString.append(secondaryDxValue.conciseLabel)
        }
        if havemobility {
            accumulateString.append(". ")
            accumulateString.append(mobilityValue.conciseLabel)
            accumulateString.append(".")
        }
        
        return accumulateString
    }
}


enum Proximity : Int, CaseIterable, Labelable {
    case notSpecified=0, TenMiles=1, TwentyFiveMiles=2, FiftyMiles=3, OneHundredMiles=4, AnyDistance=5
    static var allCases: [Proximity] {
        return [.notSpecified, .TenMiles, .TwentyFiveMiles, .FiftyMiles, .OneHundredMiles, .AnyDistance]
    }
    static let verboseMap: [Proximity: String] = [
        .notSpecified: "No Distance Specified",
        .TenMiles: "Within 10 Miles",
        .TwentyFiveMiles: "Within 25 Miles",
        .FiftyMiles: "Within 50 Miles",
        .OneHundredMiles: "Within 100 Miles",
        .AnyDistance: "Any Distance"
    ]
    var verboseLabel: String {
        return Proximity.verboseMap[self]!
    }
    static let conciseMap: [Proximity: String] = [
        .notSpecified: "None",
        .TenMiles: "within 10 mi",
        .TwentyFiveMiles: "within 25 mi",
        .FiftyMiles: "within 50 mi",
        .OneHundredMiles: "within 100 mi",
        .AnyDistance: "at any distance"
    ]
    var conciseLabel: String {
        return Proximity.conciseMap[self]!
    }
    static let distanceMap: [Proximity: Int] = [
        .notSpecified: -1,
        .TenMiles: 10,
        .TwentyFiveMiles: 25,
        .FiftyMiles: 50,
        .OneHundredMiles: 100,
        .AnyDistance: 1_000_000
    ]
    var distanceValue: Int {
        return Proximity.distanceMap[self]!
    }
}

enum MobilityLimitation : Int, CaseIterable, Labelable {
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
    var verboseLabel: String {
        return MobilityLimitation.verboseMap[self]!
    }
    static let conciseMap: [MobilityLimitation: String] = [
        .notSpecified: "None",
        .noLimitation: "No mobility limits",
        .walksWithAid: "Walks with aid",
        .wheelchair: "Uses a wheelchair"
    ]
    var conciseLabel: String {
        return MobilityLimitation.conciseMap[self]!
    }
}

enum DevelopmentalAge : Int, CaseIterable, Labelable {
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
    var verboseLabel: String {
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
    var conciseLabel: String {
        return DevelopmentalAge.conciseMap[self]!
    }
}

enum Diagnosis : Int, CaseIterable, Labelable {
    static var allCases: [Diagnosis] {
        return [.notSpecified, .autism, .cerebralPalsy, .spinaBifida, .otherDiagnosis]
    }
    case notSpecified=0, autism=1, cerebralPalsy=2, spinaBifida=3, otherDiagnosis=4

    static let verboseMap: [Diagnosis: String] = [
        .notSpecified: "No Diagnosis Specified",
        .autism: "Autism",
        .cerebralPalsy: "CP",
        .spinaBifida: "Spina Bifida",
        .otherDiagnosis: "Other Diagnosis"
    ]
    var verboseLabel: String {
        return Diagnosis.verboseMap[self]!
    }
    static let conciseMap: [Diagnosis: String] = [
        .notSpecified: "None",
        .autism: "Autism",
        .cerebralPalsy: "CP",
        .spinaBifida: "Spina Bifida",
        .otherDiagnosis: "Other Diagnosis"
    ]
    var conciseLabel: String {
        return Diagnosis.conciseMap[self]!
    }
}

