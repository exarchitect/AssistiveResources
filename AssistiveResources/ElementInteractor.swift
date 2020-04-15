//
//  ElementInteractor.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 5/22/19.
//  Copyright © 2019 SevenPlusTwo. All rights reserved.
//

import UIKit


enum EditType {
    case singleselect, numeric, multiselect
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
        case is DiagnosisFilter:
            return .multiselect
        default:
            return .singleselect
        }
    }

    init(using filterElement: FilterElement) {
        element = filterElement
        editableRowCount = element.itemCount()
        selectedEnum = element.enumRawValue()
    }

    func selectEnum(rawValue: Int) {
        selectedEnum = rawValue
        element.update(rawValue: rawValue)
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
            fatalError("in \(#function)")
        }
    }

    class func createFilterDictionary(from elementList: [ElementInteractor]) -> FilterDictionary {
        let proximity = ProximityFilter(range: Distance.twentyFiveMiles)
        var filterDict: FilterDictionary = [ProximityFilter.key: proximity]
        let age = AgeFilter(years: 21)
        filterDict[AgeFilter.key] = age
        return filterDict
    }

    class func naturalLanguageText(filters: FilterDictionary) -> String {
        var accumulateString = "Events "
        let ageFilter: AgeFilter? = filters[AgeFilter.key] as? AgeFilter
        let proximityFilter: ProximityFilter? = filters[ProximityFilter.key] as? ProximityFilter
        let mobilityValue: MobilityFilter? = filters[MobilityFilter.key] as? MobilityFilter
        let dxFilter: DiagnosisFilter? = filters[DiagnosisFilter.key] as? DiagnosisFilter

        let haveAge = ageFilter?.hasValue ?? false
        let haveProximity = proximityFilter?.hasValue ?? false
        let haveMobility = mobilityValue?.hasValue ?? false
        let haveDx = dxFilter?.hasValue ?? false

        guard haveAge || haveProximity || haveMobility || haveDx else {
            return "Upcoming events"
        }
        if let proximity = proximityFilter?.valueString {
            accumulateString.append(proximity)
        }
        if let age = ageFilter?.valueString {
            accumulateString.append(" for ")
            accumulateString.append(age)
        }
        if let primaryDx = dxFilter?.valueString {
            if ageFilter?.valueString != nil {
                accumulateString.append(" with ")
            } else {
                accumulateString.append("for someone with ")
            }
            accumulateString.append(primaryDx)
        }
        if let mobility = mobilityValue?.valueString {
            accumulateString.append(". ")
            accumulateString.append(mobility)
            accumulateString.append(".")
        }

        return accumulateString
    }

}

