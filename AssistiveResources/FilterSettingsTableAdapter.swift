//
//  FilterSettingsTableAdapter.swift
//  AssistiveResources
//
//  Created by WCJ on 1/30/18.
//  Copyright © 2018 SevenPlusTwo. All rights reserved.
//

import UIKit


//typealias FilterSelector = (_ destination:NavigationCategory) -> Void


class FilterSettingsTableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    private var filter: FilterProfile!

    init(table: UITableView, filterWhat: FilterProfile) {
        super.init()
        
        self.tableView = table
        self.filter = filterWhat
        
        // attach table
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor.white
    }
    
    
    //MARK: tableView delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 45
        if indexPath.row == 0 {
            return 50
        }
        if self.filter[indexPath.section].rowsVisible {
            return 45
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filter.count
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
//        return self.filter[section].headerTitle
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.filter[section].rowsVisible {
            return self.filter[section].editableRowCount + 1
//        } else {
//            return 1
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            // section header
            if (filter[indexPath.section].filterType == .NoCharacteristic) {
                // Major Heading
                let cell:FilterTableViewCellHeader = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCellIdentifier") as! FilterTableViewCellHeader
                cell.headerLabelOutlet.text = filter[indexPath.section].headerTitle
                
                return cell
            } else {
                // section heading
                let cell:FilterTableViewCellHeader = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCellIdentifier") as! FilterTableViewCellHeader
                cell.headerLabelOutlet.text = filter[indexPath.section].headerTitle

//                let _cellTitle = filter[indexPath.section].rowTitle(atIndex: indexPath.row+1)
                
//                let _title = navigationData[indexPath.row].title
//                let _subtitle = navigationData[indexPath.row].subtitle
//                let _image = navigationData[indexPath.row].imageName
//                cell .configureCell(title: _title, subTitle: _subtitle, imageName: _image)
                
                return cell
            }
            
        } else {
            // row cell
            let rowCellType: FilterCharacteristic = self.filter[indexPath.section].filterType
            switch rowCellType {

            case .Age:
            // age input
            let cell:FilterTableViewCellHeader = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCellIdentifier") as! FilterTableViewCellHeader
            cell.headerLabelOutlet.text = "[age data entry]"
            return cell

            case .DevelopmentalAge:
                let cell:FilterTableViewCellHeader = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCellIdentifier") as! FilterTableViewCellHeader
                cell.headerLabelOutlet.text = DevelopmentalAge.titleAtIndex[indexPath.row]
                return cell

            case .MobilityLimitation:
                let cell:FilterTableViewCellHeader = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCellIdentifier") as! FilterTableViewCellHeader
                cell.headerLabelOutlet.text = MobilityLimitation.titleAtIndex[indexPath.row]
                return cell

            case .Proximity:
                let cell:FilterTableViewCellHeader = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCellIdentifier") as! FilterTableViewCellHeader
                cell.headerLabelOutlet.text = "[proximity data entry]"
                return cell

            case .PrimaryDiagnosis, .SecondaryDiagnosis:
                let cell:FilterTableViewCellHeader = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCellIdentifier") as! FilterTableViewCellHeader
                cell.headerLabelOutlet.text = Diagnosis.titleAtIndex[indexPath.row]
                return cell

            default:
                let cell:FilterTableViewCellHeader = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCellIdentifier") as! FilterTableViewCellHeader
                return cell
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 4
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath as IndexPath, animated: true)
        
//        if indexPath.row == 0 {
            self.filter[indexPath.section].rowsVisible = !self.filter[indexPath.section].rowsVisible
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
//        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    // debug
deinit {
        print("deallocating FilterSettingsTableAdapter")
    }
}


// MARK:- Filter - generic classes

enum FilterCharacteristic : Int {
    case NoCharacteristic, Age, Proximity, DevelopmentalAge, MobilityLimitation, PrimaryDiagnosis, SecondaryDiagnosis
}

class FilterSectionDescriptor: NSObject {
    var headerTitle: String = ""
    var editableRowCount = 0
    var rowsVisible: Bool = false
    var filterType: FilterCharacteristic = .NoCharacteristic
    
    var isSelected: Bool = false
    var valueText: String = ""

    func rowTitle(atIndex: Int) -> String {
        return self.headerTitle
    }
}

class FilterProfile: NSObject {
//struct FilterProfile {

    private var sectionList:[FilterSectionDescriptor] = []
    var count: Int {
        return sectionList.count
    }
    subscript(pos: Int) -> FilterSectionDescriptor {
        return sectionList[pos]
    }
    func addSection(filter: FilterSectionDescriptor) {
        sectionList.append(filter)
    }
}


// MARK:- Filter - specific

class HeaderFilterSection: FilterSectionDescriptor {
    
    init (headerTitle: String) {
        super.init()
        self.headerTitle = headerTitle
    }
}

class ProximityFilterSection: FilterSectionDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Proximity"
        self.editableRowCount = 1
        self.rowsVisible = false
        self.filterType = .Proximity
    }
}

class AgeFilterSection: FilterSectionDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Age"
        self.editableRowCount = 1
        self.rowsVisible = false
        self.filterType = .Age
    }
    
    override func rowTitle(atIndex: Int) -> String {
        return "???"
    }
}

class DevelopmentalAgeFilterSection: FilterSectionDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Developmental Age"
        self.editableRowCount = DevelopmentalAge.caseCount - 1
        self.rowsVisible = false
        self.filterType = .DevelopmentalAge
    }
    
    override func rowTitle(atIndex: Int) -> String {
        return DevelopmentalAge.titleAtIndex[atIndex]
    }
}

class MobilityFilterSection: FilterSectionDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Mobility Limitation"
        self.editableRowCount = MobilityLimitation.caseCount - 1
        self.rowsVisible = false
        self.filterType = .MobilityLimitation
    }
    
    override func rowTitle(atIndex: Int) -> String {
        return MobilityLimitation.titleAtIndex[atIndex]
    }
}

class PrimaryDiagnosisFilterSection: FilterSectionDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Primary Diagnosis"
        self.editableRowCount = Diagnosis.caseCount - 1
        self.rowsVisible = false
        self.filterType = .PrimaryDiagnosis
    }
    
    override func rowTitle(atIndex: Int) -> String {
        return Diagnosis.titleAtIndex[atIndex]
    }
}

class SecondaryDiagnosisFilterSection: FilterSectionDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Secondary Diagnosis"
        self.editableRowCount = Diagnosis.caseCount - 1
        self.rowsVisible = false
        self.filterType = .SecondaryDiagnosis
    }
    
    override func rowTitle(atIndex: Int) -> String {
        return Diagnosis.titleAtIndex[atIndex]
    }
}



