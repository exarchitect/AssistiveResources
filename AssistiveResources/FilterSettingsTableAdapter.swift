//
//  FilterSettingsTableAdapter.swift
//  AssistiveResources
//
//  Created by WCJ on 1/30/18.
//  Copyright © 2018 SevenPlusTwo. All rights reserved.
//

import UIKit


class FilterSettingsTableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    private var filterProfile: FilterProfile!
    private var editableSectionIndex: Int = Constants.noSectionOpen

    init(table: UITableView, filterWhat: FilterProfile) {
        super.init()
        
        self.tableView = table
        self.filterProfile = filterWhat
        
        // attach table
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorColor = UIColor.white
        tableView.backgroundColor = UIColor.white
    }
    
    
    //MARK: tableView delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 68       // header
        } else {
            return self.filterProfile[indexPath.section].rowsVisible ? 45 : 0
        }
//        if self.filterProfile[indexPath.section].rowsVisible {
//            return 45       // editable row
//        } else {
//            return 0
//        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filterProfile.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterProfile[section].editableRowCount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            // section heading is first row cell so we can detect hits
            let cell:FilterTableHeaderCell = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCellIdentifier") as! FilterTableHeaderCell
            cell.headerLabelOutlet.text = filterProfile[indexPath.section].headerTitle
            cell.backgroundColor = UIColor.groupTableViewBackground
            cell.subheadLabelOutlet.text = "none specified"

            //let _cellTitle = filterProfile[indexPath.section].rowTitle(atIndex: indexPath.row+1)
            
            //let _title = navigationData[indexPath.row].title
            //let _subtitle = navigationData[indexPath.row].subtitle
            //let _image = navigationData[indexPath.row].imageName
            //cell .configureCell(title: _title, subTitle: _subtitle, imageName: _image)
            
            return cell
            
        } else {
            // row cell
            let rowCellType: FilterCharacteristic = self.filterProfile[indexPath.section].filterType
            let isSelectedRow:Bool = filterProfile[indexPath.section].selectionIndex == indexPath.row
            
            switch rowCellType {

            case .Age:
            let cell:FilterTableRowCell = tableView.dequeueReusableCell(withIdentifier: "FilterRowCellIdentifier") as! FilterTableRowCell
            cell.titleLabelOutlet.text = "[age data entry]"
            cell.checkmarkImageOutlet.isHidden = !isSelectedRow
            cell.backgroundColor = UIColor.white
            return cell

            case .DevelopmentalAge:
                let cell:FilterTableRowCell = tableView.dequeueReusableCell(withIdentifier: "FilterRowCellIdentifier") as! FilterTableRowCell
                cell.titleLabelOutlet.text = DevelopmentalAge.titleAtIndex[indexPath.row]
                cell.checkmarkImageOutlet.isHidden = !isSelectedRow
                cell.backgroundColor = UIColor.white
                return cell

            case .MobilityLimitation:
                let cell:FilterTableRowCell = tableView.dequeueReusableCell(withIdentifier: "FilterRowCellIdentifier") as! FilterTableRowCell
                cell.titleLabelOutlet.text = MobilityLimitation.titleAtIndex[indexPath.row]
                cell.checkmarkImageOutlet.isHidden = !isSelectedRow
                cell.backgroundColor = UIColor.white
                return cell

            case .Proximity:
                let cell:FilterTableRowCell = tableView.dequeueReusableCell(withIdentifier: "FilterRowCellIdentifier") as! FilterTableRowCell
                cell.titleLabelOutlet.text = ProximityToService.titleAtIndex[indexPath.row]
                cell.checkmarkImageOutlet.isHidden = !isSelectedRow
                cell.backgroundColor = UIColor.white
                return cell

            case .PrimaryDiagnosis, .SecondaryDiagnosis:
                let cell:FilterTableRowCell = tableView.dequeueReusableCell(withIdentifier: "FilterRowCellIdentifier") as! FilterTableRowCell
                cell.titleLabelOutlet.text = Diagnosis.titleAtIndex[indexPath.row]
                cell.checkmarkImageOutlet.isHidden = !isSelectedRow
                cell.backgroundColor = UIColor.white
                return cell

            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath as IndexPath, animated: true)
        
        if (self.editableSectionIndex != Constants.noSectionOpen && self.editableSectionIndex != indexPath.section) {
            self.filterProfile[editableSectionIndex].rowsVisible = false
        }
        self.editableSectionIndex = indexPath.section
        
        self.filterProfile[indexPath.section].rowsVisible = !self.filterProfile[indexPath.section].rowsVisible
        
        if indexPath.row>0 {
            let previousSelectionIndex = filterProfile[indexPath.section].selectionIndex

            let isSelectedRow:Bool = filterProfile[indexPath.section].selectionIndex == indexPath.row
            let newSelectionState:Bool = !isSelectedRow
            let newSelectionIndex = newSelectionState ? indexPath.row : Constants.noSelection
            filterProfile[indexPath.section].selectionIndex = newSelectionIndex
            let cell:FilterTableRowCell = tableView.cellForRow(at: indexPath) as! FilterTableRowCell
            cell.checkmarkImageOutlet.isHidden = !newSelectionState
            
            // deselect prev checkmark
            if (previousSelectionIndex != Constants.noSelection && previousSelectionIndex != newSelectionIndex) {
                let previouslySelectedCellIndex:IndexPath = IndexPath(row: previousSelectionIndex, section: indexPath.section)
                let previouslySelectedCell:FilterTableRowCell = tableView.cellForRow(at: previouslySelectedCellIndex) as! FilterTableRowCell
                previouslySelectedCell.checkmarkImageOutlet.isHidden = true
            }
            
            // update header with selection
            let headerCellIndex:IndexPath = IndexPath(row: 0, section: indexPath.section)
            let headerCell:FilterTableHeaderCell = tableView.cellForRow(at: headerCellIndex) as! FilterTableHeaderCell
            if (newSelectionIndex == Constants.noSelection) {
                headerCell.subheadLabelOutlet.text = "none selected"
                headerCell.subheadLabelOutlet.textColor = UIColor.darkGray
            } else {
                headerCell.subheadLabelOutlet.text = filterProfile[indexPath.section].rowTitle(atIndex: newSelectionIndex)
                headerCell.subheadLabelOutlet.textColor = UIColor.darkText
            }
        }

        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    // debug
deinit {
        print("deallocating FilterSettingsTableAdapter")
    }
}

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
enum FilterCharacteristic : Int {
    case /*NoCharacteristic,*/ Age, Proximity, DevelopmentalAge, MobilityLimitation, PrimaryDiagnosis, SecondaryDiagnosis
}

class FilterCharacteristicDescriptor: NSObject {
    var headerTitle: String = ""
    var editableRowCount = 0
    var rowsVisible: Bool = false
    var filterType: FilterCharacteristic! = nil
    var selectionIndex: Int = Constants.noSelection
    var valueText: String = ""

    func rowTitle(atIndex: Int) -> String {
        return self.headerTitle
    }
}

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


// MARK:- Filter - specific

//class HeaderFilterSection: FilterCharacteristicDescriptor {
//
//    init (headerTitle: String) {
//        super.init()
//        self.headerTitle = headerTitle
//    }
//}

class ProximityFilterSection: FilterCharacteristicDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Proximity"
        self.editableRowCount = ProximityToService.caseCount - 1
        self.filterType = .Proximity
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
        self.filterType = .Age
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
        self.filterType = .DevelopmentalAge
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
        self.filterType = .MobilityLimitation
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
        self.filterType = .PrimaryDiagnosis
    }
    
    override func rowTitle(atIndex: Int) -> String {
        return Diagnosis.titleAtIndex[atIndex]
    }
}

class SecondaryDiagnosisFilterSection: FilterCharacteristicDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Secondary Diagnosis"
        self.editableRowCount = Diagnosis.caseCount - 1
        self.filterType = .SecondaryDiagnosis
        
        //self.selectionFlags = Array(repeating: false, count: self.editableRowCount+1)
    }
    
    override func rowTitle(atIndex: Int) -> String {
        return Diagnosis.titleAtIndex[atIndex]
    }
}



