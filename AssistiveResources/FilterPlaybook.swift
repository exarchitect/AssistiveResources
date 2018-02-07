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

class FilterProfile: NSObject {
    
    private var sectionList:[FilterCharacteristicDescriptor] = []
    var count: Int {
        return sectionList.count
    }
    subscript(pos: Int) -> FilterCharacteristicDescriptor {
        return sectionList[pos]
    }
    func addSection(filter: FilterCharacteristicDescriptor) {
        sectionList.append(filter)
    }
}

class FilterCharacteristicDescriptor: NSObject {
    var headerTitle: String = ""
    var editableRowCount = 0
    var rowsVisible: Bool = false
    var selectionIndex: Int = Constants.noSelection
    
    func rowTitle(atIndex: Int) -> String {
        return self.headerTitle
    }
}

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
    
    static let titleAtIndex = ["No Developmental Age Specified", "Infant(1 year old)", "Toddler (2 year old)", "Preschool (3-5)", "Gradeschool (6-9)", "PreTeen (10-12)", "Teen (13-19)", "Adult (20+)"]
}

enum Diagnosis : Int, CaseCountable {
    case NoDiagnosisSpecified, AutismDiagnosis, CPDiagnosis, SpinaBifidaDiagnosis, OtherDiagnosis
    
    static let titleAtIndex = ["No Diagnosis Specified", "Autism", "CP", "Spina Bifida", "Other Diagnosis"]
}


// MARK:- Filter - specific

class ProximityFilterSection: FilterCharacteristicDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Proximity"
        self.editableRowCount = ProximityToService.caseCount - 1
    }
    
    override func rowTitle(atIndex: Int) -> String {
        return ProximityToService.titleAtIndex[atIndex]
    }
}

class AgeFilterSection: FilterCharacteristicDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Age"
        self.editableRowCount = 1
    }
    
    override func rowTitle(atIndex: Int) -> String {
        return "???"
    }
}

class DevelopmentalAgeFilterSection: FilterCharacteristicDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Developmental Age"
        self.editableRowCount = DevelopmentalAge.caseCount - 1
    }
    
    override func rowTitle(atIndex: Int) -> String {
        return DevelopmentalAge.titleAtIndex[atIndex]
    }
}

class MobilityFilterSection: FilterCharacteristicDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Mobility"
        self.editableRowCount = MobilityLimitation.caseCount - 1
    }
    
    override func rowTitle(atIndex: Int) -> String {
        return MobilityLimitation.titleAtIndex[atIndex]
    }
}

class PrimaryDiagnosisFilterSection: FilterCharacteristicDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Primary Diagnosis"
        self.editableRowCount = Diagnosis.caseCount - 1
    }
    
    override func rowTitle(atIndex: Int) -> String {
        return Diagnosis.titleAtIndex[atIndex]
    }
}

class SecondaryDiagnosisFilterSection: PrimaryDiagnosisFilterSection {
    
    override init () {
        super.init()
        self.headerTitle = "Secondary Diagnosis"
    }
}

