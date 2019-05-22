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
    private var filterTemplate: FilterInputTemplate!
    private var editableSectionIndex: Int = Constants.noSectionOpen

    init(table: UITableView, filterWhat: FilterInputTemplate) {
        super.init()
        
        self.tableView = table
        self.filterTemplate = filterWhat
        
        // attach table
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorColor = UIColor.white
        tableView.backgroundColor = UIColor.white
        
    }
    
    deinit {
        print("deallocating FilterSettingsTableAdapter")
    }

    //MARK: tableView delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 68       // header
        } else {
            return self.filterTemplate[indexPath.section].rowsVisible ? 45 : 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filterTemplate.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterTemplate[section].editableRowCount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            // section heading is first row cell so we can detect hits
            let cell:FilterTableHeaderCell = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCellIdentifier") as! FilterTableHeaderCell
            self.configHeaderCell(cell: cell, section: indexPath.section)

            return cell
            
        } else {
            // row for selecting an enumerated type (except for age)
            let isSelectedRow:Bool = filterTemplate[indexPath.section].selectionIndex == indexPath.row
            
            let cell:FilterTableRowCell = tableView.dequeueReusableCell(withIdentifier: "FilterRowCellIdentifier") as! FilterTableRowCell
            cell.checkmarkImageOutlet.isHidden = !isSelectedRow
            cell.backgroundColor = UIColor.white
            cell.titleLabelOutlet.text = self.filterTemplate[indexPath.section].label(at: indexPath.row)

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath as IndexPath, animated: true)
        
        if (self.editableSectionIndex != Constants.noSectionOpen && self.editableSectionIndex != indexPath.section) {
            self.filterTemplate[editableSectionIndex].rowsVisible = false
        }
        self.editableSectionIndex = indexPath.section
        
        self.filterTemplate[indexPath.section].rowsVisible = !self.filterTemplate[indexPath.section].rowsVisible
        
        if indexPath.row>0 {
            let previousSelectionIndex = filterTemplate[indexPath.section].selectionIndex

            // select row
            let isSelectedRow:Bool = filterTemplate[indexPath.section].selectionIndex == indexPath.row
            let newSelectionState:Bool = !isSelectedRow
            let newSelectionIndex = newSelectionState ? indexPath.row : Constants.noSelection
            filterTemplate[indexPath.section].select(at: newSelectionIndex)
            let cell:FilterTableRowCell = tableView.cellForRow(at: indexPath) as! FilterTableRowCell
            cell.checkmarkImageOutlet.isHidden = !newSelectionState
            
            // deselect prev checkmark
            if (previousSelectionIndex != Constants.noSelection && previousSelectionIndex != newSelectionIndex) {
                let previouslySelectedCellIndex:IndexPath = IndexPath(row: previousSelectionIndex, section: indexPath.section)
                if let previouslySelectedCell:FilterTableRowCell = tableView.cellForRow(at: previouslySelectedCellIndex) as? FilterTableRowCell {
                    // TODO - (number input)
                    previouslySelectedCell.checkmarkImageOutlet.isHidden = true
                }
            }
            
            // update header with selection
            let headerCellIndex:IndexPath = IndexPath(row: 0, section: indexPath.section)
            let headerCell:FilterTableHeaderCell = tableView.cellForRow(at: headerCellIndex) as! FilterTableHeaderCell
            self.configHeaderCell(cell: headerCell, section: indexPath.section)
        }

        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    // MARK:- utilities
    
    func configHeaderCell (cell:FilterTableHeaderCell, section:Int){
        cell.headerLabelOutlet.text = self.filterTemplate[section].element.title
        if (self.filterTemplate[section].sectionEnabled) {
            cell.headerLabelOutlet.textColor = UIColor.darkText
        } else {
            cell.headerLabelOutlet.textColor = UIColor.lightGray
        }
        cell.backgroundColor = UIColor.groupTableViewBackground
        let selectedCellIndex = self.filterTemplate[section].selectionIndex
        
        cell.setCellSubhead(text: filterTemplate[section].label(at: selectedCellIndex), disabled: !filterTemplate[section].element.hasValue)
    }
}
