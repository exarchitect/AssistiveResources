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
        selectionIndex != Constants.noSelection
    }
    var editType: EditType {
        switch element.self {
        case is AgeFilter:
            return .numeric
        default:
            return .list
        }
    }

    init(using filterElement: FilterElement) {
        element = filterElement

        switch element.self {
        case is AgeFilter:
            editableRowCount = 1
            selectionIndex = 1
        case is ProximityFilter:
            editableRowCount = Distance.allCases.count - 1
            selectionIndex = (element as! ProximityFilter).range.rawValue
        case is DevelopmentalAgeFilter:
            editableRowCount = DevelopmentalStage.allCases.count - 1
            selectionIndex = (element as! DevelopmentalAgeFilter).developmentalAge.rawValue
        case is MobilityFilter:
            editableRowCount = Limitation.allCases.count - 1
            selectionIndex = (element as! MobilityFilter).mobilityLimit.rawValue
        case is DiagnosisFilter:
            editableRowCount = DevelopmentalDiagnosis.allCases.count - 1
            selectionIndex = (element as! DiagnosisFilter).diagnosis.rawValue
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
        case is AgeFilter:
            element = AgeFilter(years: 21)
        case is ProximityFilter:
            element = ProximityFilter(range: Distance(rawValue: index)!)
        case is DevelopmentalAgeFilter:
            element = DevelopmentalAgeFilter(developmentalAge: DevelopmentalStage(rawValue: index)!)
        case is MobilityFilter:
            element = MobilityFilter(mobilityLimit: Limitation(rawValue: index)!)
        case is DiagnosisFilter:
            element = DiagnosisFilter(diagnosis: DevelopmentalDiagnosis(rawValue: index)!)
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
        case is AgeFilter:
            return (element as! AgeFilter).years.description
        case is ProximityFilter:
            return Distance.allCases[index].verbose
        case is DevelopmentalAgeFilter:
            return DevelopmentalStage.allCases[index].verbose
        case is MobilityFilter:
            return Limitation.allCases[index].verbose
        case is DiagnosisFilter:
            return DevelopmentalDiagnosis.allCases[index].verbose
        default:
            fatalError()
        }
    }

    class func createFilterDictionary(from elementList: [ElementInteractor]) -> FilterDictionary {
        let proximity = ProximityFilter(range: Distance.twentyFiveMiles)
        var filterDict: FilterDictionary = [ProximityFilter.key: proximity]
        let age = AgeFilter(years: 21)
        filterDict[AgeFilter.key] = age
        return filterDict
    }
}

