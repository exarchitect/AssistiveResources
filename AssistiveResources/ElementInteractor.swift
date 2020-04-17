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
    var editableRowCount: Int {
        element.itemCount()
    }
    var editInProgress = false
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
    }

    func summaryText(rawValue: Int) -> String {
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
        var filterDictionary: FilterDictionary = [:]

        elementList.forEach { interactor in
            if interactor.element.hasValue {
                switch interactor.element {
                case is AgeFilter:
                    filterDictionary[AgeFilter.key] = interactor.element
                case is ProximityFilter:
                    filterDictionary[ProximityFilter.key] = interactor.element
                case is DevelopmentalAgeFilter:
                    filterDictionary[DevelopmentalAgeFilter.key] = interactor.element
                case is MobilityFilter:
                    filterDictionary[MobilityFilter.key] = interactor.element
                case is DiagnosisFilter:
                    filterDictionary[DiagnosisFilter.key] = interactor.element
                default:
                    fatalError("in \(#function)")
                }
            }
        }
        return filterDictionary
    }

    class func createElementInteractorList(from dictionary: FilterDictionary) -> [ElementInteractor] {
        var filterList: [ElementInteractor] = []

        let proximityFilter = getFilter(type: ProximityFilter.self, from: dictionary)
        filterList.append(ElementInteractor(using: proximityFilter as FilterElement))
        let ageFilter = getFilter(type: AgeFilter.self, from: dictionary)
        filterList.append(ElementInteractor(using: ageFilter as FilterElement))
        let devAgeFilter = getFilter(type: DevelopmentalAgeFilter.self, from: dictionary)
        filterList.append(ElementInteractor(using: devAgeFilter as FilterElement))
        let mobilityFilter = getFilter(type: MobilityFilter.self, from: dictionary)
        filterList.append(ElementInteractor(using: mobilityFilter as FilterElement))
        let dxFilter = getFilter(type: DiagnosisFilter.self, from: dictionary)
        filterList.append(ElementInteractor(using: dxFilter as FilterElement))

        return filterList
    }

    class func naturalLanguageText(filters: FilterDictionary) -> String {
        var accumulateString = "Events "
        let ageFilter: AgeFilter? = getFilter(type: AgeFilter.self, from: filters)
        let proximityFilter: ProximityFilter? = getFilter(type: ProximityFilter.self, from: filters)
        let mobilityValue: MobilityFilter? = getFilter(type: MobilityFilter.self, from: filters)
        let dxFilter: DiagnosisFilter? = getFilter(type: DiagnosisFilter.self, from: filters)

        let haveAge = ageFilter?.hasValue ?? false
        let haveProximity = proximityFilter?.hasValue ?? false
        let haveMobility = mobilityValue?.hasValue ?? false
        let haveDx = dxFilter?.hasValue ?? false

        guard haveAge || haveProximity || haveMobility || haveDx else {
            return "Upcoming events"
        }
        if let proximity = proximityFilter?.range?.concise {
            accumulateString.append(proximity)
        }
        if haveAge == true, let age = ageFilter?.years {
            accumulateString.append(" for \(age)yo")
        }
        if haveDx, let dxSummary = dxFilter?.valueString {
            if haveAge {
                accumulateString.append(" with ")
            } else {
                accumulateString.append(" for someone with ")
            }
            accumulateString.append(dxSummary)
        }
        if let mobility = mobilityValue?.mobilityLimit?.concise {
            accumulateString.append(". " + mobility + ".")
        }

        return accumulateString
    }
}

