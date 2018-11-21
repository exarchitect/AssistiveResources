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


enum FilterType {
    case Age(years:Int)
    case Proximity(mileageBand:ProximityToService)
    case DevelopmentalAge(stage:DevelopmentalAge)
    case MobilityLimitation(mobility:MobilityLimitation)
    case PrimaryDiagnosis(primaryDx: Diagnosis)
    case SecondaryDiagnosis(secondaryDx: Diagnosis)
}

class FilterDescriptor {

    var fltrType: FilterType
    var title: String
    var editableRowCount = 0
    var sectionEnabled: Bool = true
    var rowsVisible: Bool = false
    public private(set) var selectionIndex: Int
    var haveValue: Bool {
        get {
            return selectionIndex != Constants.noSelection
        }
    }

    init(category: FilterType) {
        fltrType = category
        //self.selectionIndex = selection
        
        switch category {
        case .Age(years: let yrs):
            self.title = "Age"
            self.editableRowCount = 1
            self.selectionIndex = yrs
        case .Proximity(mileageBand: let mileage):
            self.title = "Proximity"
            self.editableRowCount = ProximityToService.caseCount - 1
            self.selectionIndex = mileage.rawValue
       case .DevelopmentalAge(stage: let devStage):
            self.title = "Developmental Age"
            self.editableRowCount = DevelopmentalAge.caseCount - 1
            self.selectionIndex = devStage.rawValue
        case .MobilityLimitation(mobility: let mobilityLimit):
            self.title = "Mobility"
            self.editableRowCount = MobilityLimitation.caseCount - 1
            self.selectionIndex = mobilityLimit.rawValue
        case .PrimaryDiagnosis(primaryDx: let dx):
            self.title = "Primary Diagnosis"
            self.editableRowCount = Diagnosis.caseCount - 1
            self.selectionIndex = dx.rawValue
        case .SecondaryDiagnosis(secondaryDx: let dx):
            self.title = "Secondary Diagnosis"
            self.editableRowCount = Diagnosis.caseCount - 1
            self.selectionIndex = dx.rawValue
        }
    }
    
    func setSelection(atIndex: Int) {
        self.selectionIndex = atIndex
        switch self.fltrType {
        case .Age:
            self.fltrType = .Age(years: atIndex)
        case .Proximity:
            self.fltrType = .Proximity(mileageBand: ProximityToService(rawValue: atIndex)!)
        case .DevelopmentalAge:
            self.fltrType = .DevelopmentalAge(stage: DevelopmentalAge(rawValue: atIndex)!)
        case .MobilityLimitation:
            self.fltrType = .MobilityLimitation(mobility: MobilityLimitation(rawValue: atIndex)!)
        case .PrimaryDiagnosis:
            self.fltrType = .PrimaryDiagnosis(primaryDx: Diagnosis(rawValue: atIndex)!)
        case .SecondaryDiagnosis:
            self.fltrType = .SecondaryDiagnosis(secondaryDx: Diagnosis(rawValue: atIndex)!)
        }
    }
    
    func labelForRow(atIndex:Int) -> String {
        var returnString:String!
        switch self.fltrType {
        case .Age(years: let yrs):
            if (yrs == 0 || yrs == -1) {
                returnString = "not set"
            } else {
                returnString = String(yrs)
            }
        case .Proximity:
            returnString = ProximityToService.titleAtIndex[atIndex]
        case .DevelopmentalAge:
            returnString = DevelopmentalAge.titleAtIndex[atIndex]
        case .MobilityLimitation:
            returnString = MobilityLimitation.titleAtIndex[atIndex]
        case .PrimaryDiagnosis:
            returnString = Diagnosis.titleAtIndex[atIndex]
        case .SecondaryDiagnosis:
            returnString = Diagnosis.titleAtIndex[atIndex]
        }
        return returnString
    }

}

class FilterInputTemplate: NSObject {
    
    private var descriptors:[FilterDescriptor] = []
    
    var count: Int {
        return descriptors.count
    }
    
    subscript(pos: Int) -> FilterDescriptor {
        return descriptors[pos]
    }
 
    func add(filter: FilterDescriptor) {
        descriptors.append(filter)
    }
    
    func createValues() -> FilterValues {
        var returnData = FilterValues()
        
        for descr in descriptors {
            switch descr.fltrType {
            case .Age(years: let yrs):
                returnData.ageValue = yrs
            case .Proximity(mileageBand: let mileage):
                returnData.proximityValue = mileage
            case .DevelopmentalAge(stage: let devStage):
                returnData.developmentalAgeValue = devStage
            case .MobilityLimitation(mobility: let mobilityLimit):
                returnData.mobilityValue = mobilityLimit
            case .PrimaryDiagnosis(primaryDx: let dx):
                returnData.primaryDxValue = dx
            case .SecondaryDiagnosis(secondaryDx: let dx):
                returnData.secondaryDxValue = dx
            }
        }
        
        return returnData
    }

}

struct FilterValues {
    
    var ageValue:Int = Constants.amountNotSpecified
    var proximityValue:ProximityToService = .NotSpecified
    var mobilityValue:MobilityLimitation = .NotSpecified
    var developmentalAgeValue:DevelopmentalAge = .NotSpecified
    var primaryDxValue:Diagnosis = .NotSpecified
    var secondaryDxValue:Diagnosis = .NotSpecified

    // Events for 21yo, dev. age preteen with autism, within 50 miles
    // "Events"
    // "within" <(mi) miles>
    // "for" <(yr)yo,> <dev. age (preteen)> "someone"
    // "with" <(primarydx)> <and (secondarydx)>
    // "who uses" (walker/aid | wheelchair>
    
    func naturalLanguageText() -> String {
        var accumulateString = "Events "
        
        // proximity
        let haveproximity = proximityValue != .NotSpecified
        if haveproximity {
            accumulateString.append(ProximityToService.labelAtIndex[proximityValue.rawValue])
        }

        // age
        let haveAge = ageValue > -1
        let haveDevAge = developmentalAgeValue != .NotSpecified
        if haveAge || haveDevAge {
            accumulateString.append(" for ")
            if haveAge {
                accumulateString.append("\(ageValue)yo")
                if haveDevAge {
                    accumulateString.append(" ")
                }
            }
            if haveDevAge {
                accumulateString.append("(dev age ")
                accumulateString.append(DevelopmentalAge.labelAtIndex[developmentalAgeValue.rawValue])
                accumulateString.append(")")
            }
        }
        
        // dx
        let haveAtLeast1dx = primaryDxValue != .NotSpecified && primaryDxValue != .OtherDiagnosis
        if haveAtLeast1dx {
            if !(haveAge || haveDevAge) {
                accumulateString.append("for someone")
            }
            accumulateString.append(" with ")
            accumulateString.append(Diagnosis.labelAtIndex[primaryDxValue.rawValue])
        }
        if secondaryDxValue != .NotSpecified && secondaryDxValue != .OtherDiagnosis {
            accumulateString.append(" and ")
            accumulateString.append(Diagnosis.labelAtIndex[secondaryDxValue.rawValue])
        }
        
//        if haveproximity || haveAge || haveDevAge || haveAtLeast1dx {
//            accumulateString.append(".")
//        }
        
        // mobility
        let havemobility = mobilityValue != .NotSpecified
        if havemobility {
            accumulateString.append(". ")
            accumulateString.append(MobilityLimitation.labelAtIndex[mobilityValue.rawValue])
        }
        
        if !(haveproximity || haveAge || haveDevAge || haveAtLeast1dx || havemobility) {
            accumulateString = "Upcoming events"
        }

        return accumulateString
    }
}


enum ProximityToService : Int, CaseCountable {
    case NotSpecified=0, TenMiles=1, TwentyFiveMiles=2, FiftyMiles=3, OneHundredMiles=4, AnyDistance=5
    static let titleAtIndex = ["No Distance Specified", "Within 10 Miles", "Within 25 Miles", "Within 50 Miles", "Within 100 Miles", "Any Distance"]
    static let distanceAtIndex:[Int] = [-1, 10, 25, 50, 100, 1_000_000]
    static let labelAtIndex:[String] = ["None", "within 10 mi", "within 25 mi", "within 50 mi", "within 100 mi", "at any distance"]
}

enum MobilityLimitation : Int, CaseCountable {
    case NotSpecified=0, NoLimitation=1, WalkWithAid=2, Wheelchair=3
    static let titleAtIndex = ["No Limitation Specified", "No Limitation", "Walk With Aid", "Wheelchair"]
    static let labelAtIndex:[String] = ["None", "No mobility limits", "Uses a walker/aid", "Uses a wheelchair"]
}

enum DevelopmentalAge : Int, CaseCountable {
    case NotSpecified=0, InfantDevelopmentalAge=1, ToddlerDevelopmentalAge=2, PreschoolDevelopmentalAge=3, GradeschoolDevelopmentalAge=4, PreTeenDevelopmentalAge=5, TeenDevelopmentalAge=6, AdultDevelopmentalAge=7
    static let titleAtIndex = ["No Developmental Age Specified", "Infant(1 year old)", "Toddler (2 year old)", "Preschool (3-5)", "Gradeschool (6-9)", "PreTeen (10-12)", "Teen (13-19)", "Adult (20+)"]
    static let labelAtIndex = ["None", "infant", "toddler", "preschool", "gradeschool", "preteen", "teen", "adult"]
}

enum Diagnosis : Int, CaseCountable {
    case NotSpecified=0, AutismDiagnosis=1, CPDiagnosis=2, SpinaBifidaDiagnosis=3, OtherDiagnosis=4
    static let titleAtIndex = ["No Diagnosis Specified", "Autism", "CP", "Spina Bifida", "Other Diagnosis"]
    static let labelAtIndex = ["None", "Autism", "CP", "Spina Bifida", "Other Diagnosis"]
}

