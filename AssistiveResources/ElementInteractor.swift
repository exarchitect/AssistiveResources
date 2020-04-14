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
    public private(set) var selectedEnum: Int
    var hasSelection: Bool {
        selectedEnum != invalidRawValue
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
        editableRowCount = element.valueCount()
        selectedEnum = element.enumRawValue()
    }

    func selectEnum(rawValue: Int) {
        selectedEnum = rawValue
        switch element {
        case is AgeFilter:
            element = AgeFilter(years: 21)
        case is ProximityFilter:
            element = ProximityFilter(range: Distance(rawValue: rawValue))
        case is DevelopmentalAgeFilter:
            element = DevelopmentalAgeFilter(developmentalAge: DevelopmentalStage(rawValue: rawValue))
        case is MobilityFilter:
            element = MobilityFilter(mobilityLimit: Limitation(rawValue: rawValue))
        case is DiagnosisFilter:
            element = DiagnosisFilter(diagnosis: DevelopmentalDiagnosis(rawValue: rawValue))
        default:
            fatalError()
        }
    }

    func enumText(rawValue: Int) -> String {
        if rawValue == -1 && !element.hasValue {
            return "not specified"
        }
        switch element {
        case is AgeFilter:
            return (element as! AgeFilter).years.description
        case is ProximityFilter:
            return Distance.allCases[rawValue].verbose
        case is DevelopmentalAgeFilter:
            return DevelopmentalStage.allCases[rawValue].verbose
        case is MobilityFilter:
            return Limitation.allCases[rawValue].verbose
        case is DiagnosisFilter:
            return DevelopmentalDiagnosis.allCases[rawValue].verbose
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

