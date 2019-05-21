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
    case titleOnly, valueOnly, abbreviatedPhrase, fullPhrase, nilValue
}
protocol Nameable {
    func render (_ renderType: RenderType) -> String
}

enum FilteringElement: Nameable {
    case age(years:Int)
    case proximity(mileageBand:ProximityTo)
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
            if renderType == .valueOnly { return String(yrs) }
            if renderType == .abbreviatedPhrase { return "\(yrs)yo" }
            if renderType == .fullPhrase { return "\(yrs) year old" }

        case .proximity(let mileageBand):
            if renderType == .titleOnly { return "Proximity" }
            if renderType == .nilValue { return "none selected" }
            if renderType == .abbreviatedPhrase { return ProximityTo.conciseLabel[mileageBand.rawValue] }
            if renderType == .fullPhrase { return ProximityTo.verboseLabel[mileageBand.rawValue] }

        case .developmentalAge(let stage):
            if renderType == .titleOnly { return "Developmental Age" }
            if renderType == .nilValue { return "none selected" }
            if renderType == .abbreviatedPhrase { return DevelopmentalAge.conciseLabel[stage.rawValue] }
            if renderType == .fullPhrase { return DevelopmentalAge.verboseLabel[stage.rawValue] }

        case .mobilityLimitation(let mobility):
            if renderType == .titleOnly { return "Mobility" }
            if renderType == .nilValue { return "none selected" }
            if renderType == .abbreviatedPhrase { return MobilityLimitation.conciseLabel[mobility.rawValue] }
            if renderType == .fullPhrase { return MobilityLimitation.verboseLabel[mobility.rawValue] }

        case .primaryDiagnosis(let primaryDx):
            if renderType == .titleOnly { return "Primary Diagnosis" }
            if renderType == .nilValue { return "none selected" }
            if renderType == .abbreviatedPhrase { return Diagnosis.conciseLabel[primaryDx.rawValue] }
            if renderType == .fullPhrase { return Diagnosis.verboseLabel[primaryDx.rawValue] }

        case .secondaryDiagnosis(let secondaryDx):
            if renderType == .titleOnly { return "Secondary Diagnosis" }
            if renderType == .nilValue { return "none selected" }
            if renderType == .abbreviatedPhrase { return Diagnosis.conciseLabel[secondaryDx.rawValue] }
            if renderType == .fullPhrase { return Diagnosis.verboseLabel[secondaryDx.rawValue] }
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
            self.editableRowCount = ProximityTo.caseCount - 1
            self.selectionIndex = mileage.rawValue
        case .developmentalAge(stage: let devStage):
            self.editableRowCount = DevelopmentalAge.caseCount - 1
            self.selectionIndex = devStage.rawValue
        case .mobilityLimitation(mobility: let mobilityLimit):
            self.editableRowCount = MobilityLimitation.caseCount - 1
            self.selectionIndex = mobilityLimit.rawValue
        case .primaryDiagnosis(primaryDx: let dx):
            self.editableRowCount = Diagnosis.caseCount - 1
            self.selectionIndex = dx.rawValue
        case .secondaryDiagnosis(secondaryDx: let dx):
            self.editableRowCount = Diagnosis.caseCount - 1
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
            self.element = .proximity(mileageBand: ProximityTo(rawValue: index)!)
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
            returnString = FilteringElement.age(years: yrs).render(.abbreviatedPhrase)
        case .proximity:
            returnString = ProximityTo.verboseLabel[atIndex]
        case .developmentalAge:
            returnString = DevelopmentalAge.verboseLabel[atIndex]
        case .mobilityLimitation:
            returnString = MobilityLimitation.verboseLabel[atIndex]
        case .primaryDiagnosis:
            returnString = Diagnosis.verboseLabel[atIndex]
        case .secondaryDiagnosis:
            returnString = Diagnosis.verboseLabel[atIndex]
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
    var proximityValue:ProximityTo = .NotSpecified
    var mobilityValue:MobilityLimitation = .NotSpecified
    var developmentalAgeValue:DevelopmentalAge = .NotSpecified
    var primaryDxValue:Diagnosis = .NotSpecified
    var secondaryDxValue:Diagnosis = .NotSpecified

    // Events for 21yo, dev. age preteen with autism, within 50 miles
    // "Events"
    // "within" <(mi) miles>
    // "for" <(yr)yo> "someone"
    // "with" <(primarydx)> <and (secondarydx)>
    // "who uses" (walker/aid | wheelchair>
    // TODO developmental age
    
    func naturalLanguageText() -> String {
        var accumulateString = "Events "
        
        let haveproximity = proximityValue != .NotSpecified
        let haveAge = ageValue > -1
        let haveDevAge = developmentalAgeValue != .NotSpecified
        let haveAtLeast1dx = primaryDxValue != .NotSpecified && primaryDxValue != .OtherDiagnosis
        let havemobility = mobilityValue != .NotSpecified

        guard haveproximity || haveAge || haveDevAge || haveAtLeast1dx || havemobility else {
            return "Upcoming events"
        }

        // proximity
        if haveproximity {
            accumulateString.append(ProximityTo.conciseLabel[proximityValue.rawValue])
        }

        // age
        if haveAge {
            accumulateString.append(" for ")
            if haveAge {
                accumulateString.append("\(ageValue)yo")
                //if haveDevAge { accumulateString.append(" ") }
            }
        }
        
        // dx
        if haveAtLeast1dx {
            if !haveAge { accumulateString.append("for someone") }
            accumulateString.append(" with ")
            accumulateString.append(Diagnosis.conciseLabel[primaryDxValue.rawValue])
        }
        if secondaryDxValue != .NotSpecified && secondaryDxValue != .OtherDiagnosis {
            accumulateString.append(" & ")
            accumulateString.append(Diagnosis.conciseLabel[secondaryDxValue.rawValue])
        }

        // mobility
        if havemobility {
            accumulateString.append(". ")
            accumulateString.append(MobilityLimitation.conciseLabel[mobilityValue.rawValue])
            accumulateString.append(".")
        }
        
        return accumulateString
    }
}


enum ProximityTo : Int, CaseCountable {
    case NotSpecified=0, TenMiles=1, TwentyFiveMiles=2, FiftyMiles=3, OneHundredMiles=4, AnyDistance=5
    static let distanceValue:[Int] = [-1, 10, 25, 50, 100, 1_000_000]
    static let verboseLabel = ["No Distance Specified", "Within 10 Miles", "Within 25 Miles", "Within 50 Miles", "Within 100 Miles", "Any Distance"]
    static let conciseLabel:[String] = ["None", "within 10 mi", "within 25 mi", "within 50 mi", "within 100 mi", "at any distance"]
}

enum MobilityLimitation : Int, CaseCountable {
    case NotSpecified=0, NoLimitation=1, WalkWithAid=2, Wheelchair=3
    static let verboseLabel = ["No Limitation Specified", "No Limitation", "Walks With Aid", "Uses A Wheelchair"]
    static let conciseLabel:[String] = ["None", "No mobility limits", "Walks with aid", "Uses a wheelchair"]
}

enum DevelopmentalAge : Int, CaseCountable {
    case NotSpecified=0, InfantDevelopmentalAge=1, ToddlerDevelopmentalAge=2, PreschoolDevelopmentalAge=3, GradeschoolDevelopmentalAge=4, PreTeenDevelopmentalAge=5, TeenDevelopmentalAge=6, AdultDevelopmentalAge=7
    static let verboseLabel = ["No Developmental Age Specified", "Infant(1 year old)", "Toddler (2 year old)", "Preschool (3-5)", "Gradeschool (6-9)", "PreTeen (10-12)", "Teen (13-19)", "Adult (20+)"]
    static let conciseLabel = ["None", "infant", "toddler", "preschool", "gradeschool", "preteen", "teen", "adult"]
}

enum Diagnosis : Int, CaseCountable {
    case NotSpecified=0, AutismDiagnosis=1, CPDiagnosis=2, SpinaBifidaDiagnosis=3, OtherDiagnosis=4
    static let verboseLabel = ["No Diagnosis Specified", "Autism", "CP", "Spina Bifida", "Other Diagnosis"]
    static let conciseLabel = ["None", "Autism", "CP", "Spina Bifida", "Other Diagnosis"]
}

