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


class FltrDescriptor {

    enum FltrType {
        case Age(years:Int)
        case Proximity(mileageBand:ProximityToService)
        case DevelopmentalAge(stage:DevelopmentalAge)
        case MobilityLimitation(mobility:MobilityLimitation)
        case PrimaryDiagnosis(primaryDx: Diagnosis)
        case SecondaryDiagnosis(secondaryDx: Diagnosis)
    }

    var fltrType: FltrType
    var title: String
    var editableRowCount = 0
    var sectionEnabled: Bool = true
    var rowsVisible: Bool = false
    var selectionIndex: Int = Constants.noSelection

    init(category: FltrType,selection:Int = -1) {
        fltrType = category
        self.selectionIndex = selection
        
        switch category {
        case .Age:
            self.title = "Age"
            self.editableRowCount = 1
        case .Proximity:
            self.title = "Proximity"
            self.editableRowCount = ProximityToService.caseCount - 1
        case .DevelopmentalAge:
            self.title = "Developmental Age"
            self.editableRowCount = DevelopmentalAge.caseCount - 1
        case .MobilityLimitation:
            self.title = "Mobility"
            self.editableRowCount = MobilityLimitation.caseCount - 1
        case .PrimaryDiagnosis:
            self.title = "Primary Diagnosis"
            self.editableRowCount = Diagnosis.caseCount - 1
        case .SecondaryDiagnosis:
            self.title = "Secondary Diagnosis"
            self.editableRowCount = Diagnosis.caseCount - 1
        }
    }
    
    func labelForRow(atIndex:Int) -> String {
        var returnString:String!
        switch self.fltrType {
        case .Age:
            returnString = "???"
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


class FltrProfile: NSObject {
    
    private var descriptors:[FltrDescriptor] = []
    
    var count: Int {
        return descriptors.count
    }
    
    subscript(pos: Int) -> FltrDescriptor {
        return descriptors[pos]
    }
 
    func add(filter: FltrDescriptor) {
        descriptors.append(filter)
    }
}


//-------------- existing ----------------


//class FilterProfile: NSObject {
//
//    private var sectionList:[FilterCharacteristicDescriptor] = []
//    var count: Int {
//        return sectionList.count
//    }
//    subscript(pos: Int) -> FilterCharacteristicDescriptor {
//        return sectionList[pos]
//    }
//    func addSection(filter: FilterCharacteristicDescriptor) {
//        sectionList.append(filter)
//    }
//}
//
//class FilterCharacteristicDescriptor: NSObject {
//    var headerTitle: String = ""
//    var editableRowCount = 0
//    var sectionEnabled: Bool = true
//    var rowsVisible: Bool = false
//    var selectionIndex: Int = Constants.noSelection
//
//    func rowTitle(atIndex: Int) -> String {
//        return self.headerTitle
//    }
//}

enum ProximityToService : Int, CaseCountable {
    case NotSpecified=0, TenMiles=1, TwentyFiveMiles=2, FiftyMiles=3, OneHundredMiles=4, AnyDistance=5
    static let titleAtIndex = ["No Distance Specified", "Within 10 Miles", "Within 25 Miles", "Within 50 Miles", "Within 100 Miles", "Any Distance"]
    static let distanceAtIndex:[Int] = [-1, 10, 25, 50, 100, 1_000_000]
}

enum MobilityLimitation : Int, CaseCountable {
    case NotSpecified=0, NoLimitation=1, WalkWithAid=2, Wheelchair=3
    static let titleAtIndex = ["No Limitation Specified", "No Limitation", "Walk With Aid", "Wheelchair"]
}

enum DevelopmentalAge : Int, CaseCountable {
    case NotSpecified=0, InfantDevelopmentalAge=1, ToddlerDevelopmentalAge=2, PreschoolDevelopmentalAge=3, GradeschoolDevelopmentalAge=4, PreTeenDevelopmentalAge=5, TeenDevelopmentalAge=6, AdultDevelopmentalAge=7
    static let titleAtIndex = ["No Developmental Age Specified", "Infant(1 year old)", "Toddler (2 year old)", "Preschool (3-5)", "Gradeschool (6-9)", "PreTeen (10-12)", "Teen (13-19)", "Adult (20+)"]
}

enum Diagnosis : Int, CaseCountable {
    case NotSpecified=0, AutismDiagnosis=1, CPDiagnosis=2, SpinaBifidaDiagnosis=3, OtherDiagnosis=4
    static let titleAtIndex = ["No Diagnosis Specified", "Autism", "CP", "Spina Bifida", "Other Diagnosis"]
}


// MARK:- Filter - specific

//class ProximityFilterSection: FilterCharacteristicDescriptor {
//    
//    override init () {
//        super.init()
//        self.headerTitle = "Proximity"
//        self.editableRowCount = ProximityToService.caseCount - 1
//    }
//    
//    override func rowTitle(atIndex: Int) -> String {
//        return ProximityToService.titleAtIndex[atIndex]
//    }
//}
//
//class AgeFilterSection: FilterCharacteristicDescriptor {
//    
//    override init () {
//        super.init()
//        self.headerTitle = "Age"
//        self.editableRowCount = 1
//    }
//    
//    override func rowTitle(atIndex: Int) -> String {
//        return "???"
//    }
//}
//
//class DevelopmentalAgeFilterSection: FilterCharacteristicDescriptor {
//    
//    override init () {
//        super.init()
//        self.headerTitle = "Developmental Age"
//        self.editableRowCount = DevelopmentalAge.caseCount - 1
//    }
//    
//    override func rowTitle(atIndex: Int) -> String {
//        return DevelopmentalAge.titleAtIndex[atIndex]
//    }
//}
//
//class MobilityFilterSection: FilterCharacteristicDescriptor {
//    
//    override init () {
//        super.init()
//        self.headerTitle = "Mobility"
//        self.editableRowCount = MobilityLimitation.caseCount - 1
//    }
//    
//    override func rowTitle(atIndex: Int) -> String {
//        return MobilityLimitation.titleAtIndex[atIndex]
//    }
//}
//
//class PrimaryDiagnosisFilterSection: FilterCharacteristicDescriptor {
//    
//    override init () {
//        super.init()
//        self.headerTitle = "Primary Diagnosis"
//        self.editableRowCount = Diagnosis.caseCount - 1
//    }
//    
//    override func rowTitle(atIndex: Int) -> String {
//        return Diagnosis.titleAtIndex[atIndex]
//    }
//}
//
//class SecondaryDiagnosisFilterSection: PrimaryDiagnosisFilterSection {
//    
//    override init () {
//        super.init()
//        self.headerTitle = "Secondary Diagnosis"
//        self.sectionEnabled = false
//    }
//}

