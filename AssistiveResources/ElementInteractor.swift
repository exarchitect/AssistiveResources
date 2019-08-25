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
//    case diagnoses(_ dx: [Diagnosis])
    case diagnoses(dx:Diagnoses)

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
        case .diagnoses(let dx):
//            return dx.isEmpty ? false : dx[0].hasValue
            return dx.hasValue
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
        case .diagnoses:
            return "Diagnosis"
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
        case .diagnoses:
            returnString = Diagnosis.allCases[index].verboseValue
//            returnString = Diagnoses.verboseValue
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
        case .diagnoses(dx: let dxs):
            self.editableRowCount = Diagnosis.allCases.count - 1
//            self.selectionIndex = dx.rawValue
            self.selectionIndex = dxs.hasValue ? dxs.dx[0].rawValue : 0
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
        case .diagnoses:
            var dxs: Diagnoses = Diagnoses()
            dxs.dx.append(Diagnosis(rawValue: index+1)!)
            self.element = .diagnoses(dx: dxs)
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
            case .diagnoses(dx: let dxs):
                returnData.diagnoses = dxs
            }
        }
        return returnData
    }
}

