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

func getFilterElement<T: FilterElement>(type: T.Type, from dictionary: FilterDictionary) -> T {
    let dictionaryEntry: T? = dictionary[T.key] as? T

    if dictionaryEntry != nil {
        return dictionaryEntry!
    }
    switch type {
    case is AgeFilter.Type:
        return AgeFilter() as! T
    case is ProximityFilter.Type:
        return ProximityFilter() as! T
    case is DevelopmentalAgeFilter.Type:
        return DevelopmentalAgeFilter() as! T
    case is MobilityFilter.Type:
        return MobilityFilter() as! T
    case is DiagnosisFilter.Type:
        return DiagnosisFilter(diagnoses: []) as! T
    default:
        fatalError("in \(#function)")
    }
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
            let ageFilter = (element as! AgeFilter)
            guard ageFilter.hasValue == true else {
                return "not specified"
            }
            return (element as! AgeFilter).subtitleString
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

        let proximityFilter = getFilterElement(type: ProximityFilter.self, from: dictionary)
        filterList.append(ElementInteractor(using: proximityFilter as FilterElement))
        let ageFilter = getFilterElement(type: AgeFilter.self, from: dictionary)
        filterList.append(ElementInteractor(using: ageFilter as FilterElement))
        let devAgeFilter = getFilterElement(type: DevelopmentalAgeFilter.self, from: dictionary)
        filterList.append(ElementInteractor(using: devAgeFilter as FilterElement))
        let mobilityFilter = getFilterElement(type: MobilityFilter.self, from: dictionary)
        filterList.append(ElementInteractor(using: mobilityFilter as FilterElement))
        let dxFilter = getFilterElement(type: DiagnosisFilter.self, from: dictionary)
        filterList.append(ElementInteractor(using: dxFilter as FilterElement))

        return filterList
    }

    class func naturalLanguageText(filters: FilterDictionary) -> String {
        var accumulateString = "Events "
        let ageFilter: AgeFilter? = getFilterElement(type: AgeFilter.self, from: filters)
        let proximityFilter: ProximityFilter? = getFilterElement(type: ProximityFilter.self, from: filters)
        let mobilityValue: MobilityFilter? = getFilterElement(type: MobilityFilter.self, from: filters)
        let dxFilter: DiagnosisFilter? = getFilterElement(type: DiagnosisFilter.self, from: filters)

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
        if haveAge == true, let age = ageFilter?.age {
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

