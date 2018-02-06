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
            let cell:FilterTableViewCellHeader = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCellIdentifier") as! FilterTableViewCellHeader
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
            switch rowCellType {

            case .Age:
            let cell:FilterTableViewCellHeader = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCellIdentifier") as! FilterTableViewCellHeader
            cell.headerLabelOutlet.text = "[age data entry]"
            cell.backgroundColor = UIColor.white
            cell.subheadLabelOutlet.text = ""
            return cell

            case .DevelopmentalAge:
                let cell:FilterTableViewCellHeader = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCellIdentifier") as! FilterTableViewCellHeader
                cell.headerLabelOutlet.text = DevelopmentalAge.titleAtIndex[indexPath.row]
                cell.backgroundColor = UIColor.white
                cell.subheadLabelOutlet.text = ""
                return cell

            case .MobilityLimitation:
                let cell:FilterTableViewCellHeader = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCellIdentifier") as! FilterTableViewCellHeader
                cell.headerLabelOutlet.text = MobilityLimitation.titleAtIndex[indexPath.row]
                cell.backgroundColor = UIColor.white
                cell.subheadLabelOutlet.text = ""
                return cell

            case .Proximity:
                let cell:FilterTableViewCellHeader = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCellIdentifier") as! FilterTableViewCellHeader
                cell.headerLabelOutlet.text = ProximityToService.titleAtIndex[indexPath.row]
                cell.backgroundColor = UIColor.white
                cell.subheadLabelOutlet.text = ""
                return cell

            case .PrimaryDiagnosis, .SecondaryDiagnosis:
                let cell:FilterTableViewCellHeader = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCellIdentifier") as! FilterTableViewCellHeader
                cell.headerLabelOutlet.text = Diagnosis.titleAtIndex[indexPath.row]
                cell.backgroundColor = UIColor.white
                cell.subheadLabelOutlet.text = ""
                return cell

            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath as IndexPath, animated: true)
        
        self.filterProfile[indexPath.section].rowsVisible = !self.filterProfile[indexPath.section].rowsVisible
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

enum FilterCharacteristic : Int {
    case /*NoCharacteristic,*/ Age, Proximity, DevelopmentalAge, MobilityLimitation, PrimaryDiagnosis, SecondaryDiagnosis
}

class FilterCharacteristicDescriptor: NSObject {
    var headerTitle: String = ""
    var editableRowCount = 0
    var rowsVisible: Bool = false
    var filterType: FilterCharacteristic! = nil
    
    var isSelected: Bool = false
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
        self.rowsVisible = false
        self.filterType = .Proximity
    }
}

class AgeFilterSection: FilterCharacteristicDescriptor {
    
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

class DevelopmentalAgeFilterSection: FilterCharacteristicDescriptor {
    
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

class MobilityFilterSection: FilterCharacteristicDescriptor {
    
    override init () {
        super.init()
        self.headerTitle = "Mobility"
        self.editableRowCount = MobilityLimitation.caseCount - 1
        self.rowsVisible = false
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
        self.rowsVisible = false
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
        self.rowsVisible = false
        self.filterType = .SecondaryDiagnosis
    }
    
    override func rowTitle(atIndex: Int) -> String {
        return Diagnosis.titleAtIndex[atIndex]
    }
}



