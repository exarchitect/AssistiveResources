//
//  ElementInteractor.swift
//  AssistiveResources
//
//  Created by WCJ on 5/22/19.
//  Copyright © 2019 SevenPlusTwo. All rights reserved.
//

import UIKit


enum EditType {
    case list, numeric
}

class ElementInteractor: NSObject {
    var element: FilterElement
    var editableRowCount = 0
    var sectionEnabled = true
    var rowsVisible = false
    public private(set) var selectionIndex: Int
    var hasSelection: Bool {
        return selectionIndex != Constants.noSelection
    }
    var editType: EditType {
        switch element.self {
        case is AgeClass:
            return .numeric
        default:
            return .list
        }
    }

    init(using filterElement: FilterElement) {
        element = filterElement

        switch element.self {
        case is AgeClass:
            editableRowCount = 1
            selectionIndex = 1
        case is ProximityClass:
            editableRowCount = Distance.allCases.count - 1
            selectionIndex = (element as! ProximityClass).range.rawValue
        case is DevelopmentalAgeClass:
            editableRowCount = DevelopmentalStage.allCases.count - 1
            selectionIndex = (element as! DevelopmentalAgeClass).developmentalAge.rawValue
        case is MobilityClass:
            editableRowCount = Limitation.allCases.count - 1
            selectionIndex = (element as! MobilityClass).mobilityLimit.rawValue
        case is DiagnosisClass:
            editableRowCount = DevelopmentalDiagnosis.allCases.count - 1
            selectionIndex = (element as! DiagnosisClass).diagnosis.rawValue
//        case .additionalDiagnoses(secondaryDx: let dx):
//            editableRowCount = Diagnosis.allCases.count - 1
//            selectionIndex = dx.rawValue
        default:
            fatalError()
        }
    }

    func selectItem(at index: Int) {
        selectionIndex = index
        switch element {
        case is AgeClass:
            element = AgeClass(years: 21)
        case is ProximityClass:
            element = ProximityClass(range: Distance(rawValue: index)!)
        case is DevelopmentalAgeClass:
            element = DevelopmentalAgeClass(developmentalAge: DevelopmentalStage(rawValue: index)!)
        case is MobilityClass:
            element = MobilityClass(mobilityLimit: Limitation(rawValue: index)!)
        case is DiagnosisClass:
            element = DiagnosisClass(diagnosis: DevelopmentalDiagnosis(rawValue: index)!)
//        case .additionalDiagnoses:
//            self.element = .additionalDiagnoses(secondaryDx: Diagnosis(rawValue: index)!)
            default:
                fatalError()
        }
    }

    func itemText(at index:Int) -> String {
        if index == 0 && !element.hasValue {
            return "not specified"
        }
        switch element {
        case is AgeClass:
            return (element as! AgeClass).years.description
        case is ProximityClass:
            return Distance.allCases[index].verbose
        case is DevelopmentalAgeClass:
            return DevelopmentalStage.allCases[index].verbose
        case is MobilityClass:
            return Limitation.allCases[index].verbose
        case is DiagnosisClass:
            return DevelopmentalDiagnosis.allCases[index].verbose
        default:
            fatalError()
        }
    }

    class func createFilterDictionary(from elementList: [ElementInteractor]) -> FilterDictionary {
        let proximity = ProximityClass(range: Distance.twentyFiveMiles)
        var filterDict: FilterDictionary = [ProximityClass.key: proximity]
        let age = AgeClass(years: 21)
        filterDict[AgeClass.key] = age
        return filterDict
    }
}

