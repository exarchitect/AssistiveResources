//
//  ElementInteractor.swift
//  AssistiveResources
//
//  Created by WCJ on 5/22/19.
//  Copyright © 2019 SevenPlusTwo. All rights reserved.
//

import UIKit

enum FilteringElement {
    case age(years:Age)
    case proximity(mileageBand:Proximity)
    case developmentalAge(stage:DevelopmentalAge)
    case mobilityLimitation(mobility:MobilityLimitation)
    case primaryDiagnosis(primaryDx: Diagnosis)
    case additionalDiagnoses(secondaryDx: Diagnosis)

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
        case .additionalDiagnoses(let secondaryDx):
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
        case .additionalDiagnoses:
            return "Other Diagnoses"
        }
    }
    func itemText(at index:Int) -> String {
        var returnString:String
        if index==0 && !self.hasValue { return "not specified" }
        switch self {
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
        case .additionalDiagnoses:
            returnString = Diagnosis.allCases[index].verboseValue
        }
        return returnString
    }
}

enum EditType {
    case list, numeric
}

class ElementInteractor: NSObject {
    var element: FilteringElement
    var editableRowCount = 0
    var sectionEnabled: Bool = true
    var rowsVisible: Bool = false
    public private(set) var selectionIndex: Int
    var hasSelection: Bool {
        return selectionIndex != Constants.noSelection
    }
    var editType: EditType {
        switch self.element {
        case .age:
            return .numeric
        default:
            return .list
        }
    }

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
        case .additionalDiagnoses(secondaryDx: let dx):
            self.editableRowCount = Diagnosis.allCases.count - 1
            self.selectionIndex = dx.rawValue
        }
    }

    func selectItem(at index: Int) {
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
        case .additionalDiagnoses:
            self.element = .additionalDiagnoses(secondaryDx: Diagnosis(rawValue: index)!)
        }
    }
}

class FilterInputTemplate: NSObject {

    private var elements:[ElementInteractor] = []

    var elementCount: Int {
        return elements.count
    }

    subscript(pos: Int) -> ElementInteractor {
        return elements[pos]
    }

    func add(filterType: ElementInteractor) {
        elements.append(filterType)
    }

    func createFilterProfile() -> FilterProfile {
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
            case .additionalDiagnoses(secondaryDx: let dx):
                returnData.secondaryDxValue = dx
            }
        }
        return returnData
    }
}

