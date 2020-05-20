//
//  FilterSettingsTableAdapter.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/30/18.
//  Copyright © 2018 SevenPlusTwo. All rights reserved.
//

// This was previously a separate object used by EventFilterViewController, but UIAlertController
// will not work correctly unless called from a view controller.

import UIKit

extension EventFilterViewController: UITableViewDelegate, UITableViewDataSource {

    func initTable(filterBy: FilterDictionary) {
        self.filterItems = ElementInteractor.createElementInteractorList(from: filterBy)

        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorInset = UIEdgeInsets.zero
        tableView?.separatorColor = UIColor.white
        tableView?.backgroundColor = UIColor.white
    }
    
    //MARK: tableView delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 68       // header
        } else {
            return filterItems[indexPath.section].editInProgress ? 45 : 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filterItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterItems[section].editableRowCount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            // section heading is first row cell so we can detect hits
            let cell: FilterTableHeaderCell = tableView.dequeueReusableCell(withIdentifier: "FilterHeaderCellIdentifier") as! FilterTableHeaderCell
            configHeaderCell(cell: cell, section: indexPath.section)
            return cell
            
        } else {
            // row for selecting an enumerated type (except for age)
            let isSelectedRow = filterItems[indexPath.section].element.isValueSelected(rawValue: indexPath.row.convertToEnum())
            let cell: FilterTableRowCell = tableView.dequeueReusableCell(withIdentifier: "FilterRowCellIdentifier") as! FilterTableRowCell
            cell.configure(text: self.filterItems[indexPath.section].summaryText(rawValue: indexPath.row.convertToEnum()), isChecked: isSelectedRow)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)

        switch filterItems[indexPath.section].editType {
        case .singleselect:
            selectListCell(at: indexPath)
        case .multiselect:
            selectMultiCell(at: indexPath)
        case .numeric:
            selectNumericCell(at: indexPath)
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // MARK:- utilities
    
    private func configHeaderCell (cell:FilterTableHeaderCell, section:Int){
        let subtitle = filterItems[section].element.valueString
        cell.configure (mainText: self.filterItems[section].element.label,
                        headerEnabled: true,
                        subText: subtitle,
                        subTextEnabled: filterItems[section].element.hasValue)
    }

    private func selectMultiCell(at indexPath: IndexPath) {
        showHideSections(at: indexPath, multiSelect: true)

        // update rows
        if indexPath.row > 0 {
            filterItems[indexPath.section].element.toggleSelection(rawValue: indexPath.row.convertToEnum())
            updateSectionCheckmarks(for: indexPath.section)

            // update header with selection
            let headerCellIndex = IndexPath(row: 0, section: indexPath.section)
            guard let headerCell = tableView?.cellForRow(at: headerCellIndex) as? FilterTableHeaderCell else {
                return
            }
            configHeaderCell(cell: headerCell, section: indexPath.section)
        }
    }

    private func selectListCell(at indexPath: IndexPath) {
        showHideSections(at: indexPath)

        // update rows
        if indexPath.row > 0 {
            filterItems[indexPath.section].element.toggleSelection(rawValue: indexPath.row.convertToEnum())
            updateSectionCheckmarks(for: indexPath.section)

            // update header with selection
            let headerCellIndex = IndexPath(row: 0, section: indexPath.section)
            guard let headerCell = tableView?.cellForRow(at: headerCellIndex) as? FilterTableHeaderCell else {
                return
            }
            configHeaderCell(cell: headerCell, section: indexPath.section)
        }
    }

    private func selectNumericCell(at indexPath: IndexPath) {
        if indexPath.row == 0 {
            showHideSections(at: indexPath)
        }

        // tap row cell
        if indexPath.row > 0 {
            guard var ageFilter = filterItems[indexPath.section].element as? AgeFilter, let month = ageFilter.monthOfBirth, let year = ageFilter.yearOfBirth else {
            return
        }
            selectMonthYearOfBirth(dobMonth: month, dobYear: year) { (_ dobMonth: Int?, _ dobYear: Int?) in
                guard let dobMonth = dobMonth, let dobYear = dobYear else {
                    return
                }
                ageFilter.setDOB(month: dobMonth, year: dobYear)
                self.filterItems[indexPath.section].element = ageFilter     // ageFilter is passed by value so replace the previous one

                // the row text changes for the age filter and must be redrawn
                guard let rowCell = self.tableView?.cellForRow(at: indexPath) as? FilterTableRowCell else {
                    return
                }
                rowCell.configure(text: self.filterItems[indexPath.section].summaryText(rawValue: indexPath.row.convertToEnum()))
                self.updateSectionCheckmarks(for: indexPath.section)

                // update header with selection
                let headerCellIndex = IndexPath(row: 0, section: indexPath.section)
                guard let headerCell = self.tableView?.cellForRow(at: headerCellIndex) as? FilterTableHeaderCell else {
                    return
                }
                self.configHeaderCell(cell: headerCell, section: indexPath.section)
            }
        }
    }

    private func showHideSections(at indexPath: IndexPath, multiSelect: Bool = false) {
        let previousEditableSectionIndex = filterItems.firstIndex { $0.editInProgress == true }

        // hide previous editable section if open and different section is becoming editable
        if let previousSectionIndex = previousEditableSectionIndex, previousSectionIndex != indexPath.section {
            filterItems[previousSectionIndex].editInProgress = false
        }

        if multiSelect {
            // reveal section if hidden (dont auto-hide)
            if filterItems[indexPath.section].editInProgress == false {
                filterItems[indexPath.section].editInProgress = true
            } else if indexPath.row == 0 {
                filterItems[indexPath.section].editInProgress = false
            }
        } else {
            // set section visible/hidden
            filterItems[indexPath.section].editInProgress = !self.filterItems[indexPath.section].editInProgress
        }
    }

    private func updateSectionCheckmarks(for section: Int) {
        let rowCount = filterItems[section].editableRowCount
        for rowIndex in 1 ... rowCount {
            let isSelected = filterItems[section].element.isValueSelected(rawValue: rowIndex.convertToEnum())
            guard let cell: FilterTableRowCell = tableView?.cellForRow(at: IndexPath(row: rowIndex, section: section)) as? FilterTableRowCell else {
                return
            }
            cell.checkmarkImageOutlet.isHidden = !isSelected
            cell.backgroundView?.setNeedsDisplay()
        }
    }
}

extension Int {
    func convertToEnum() -> Int {
        self - 1
    }
}

extension EventFilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func selectMonthYearOfBirth(dobMonth: Int, dobYear: Int, closure: @escaping (_ dobMonth: Int?, _ dobYear: Int?) -> Void) {
        let alert = UIAlertController(title: "Select Birth Month and Year", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alert.isModalInPopover = true

        let picker = UIPickerView(frame: CGRect(x: 5, y: 30, width: 250, height: 140))

        alert.view.addSubview(picker)
        picker.dataSource = self
        picker.delegate = self
        picker.selectRow(dobMonth - 1, inComponent: 0, animated: false)
        picker.selectRow(pickerData.yearToIndex(dobYear), inComponent: 1, animated: false)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            closure(nil, nil)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            closure(self.pickerData.month, self.pickerData.year)
        }))
        present(alert, animated: true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return pickerData.months[row]
        case 1:
            return "\(pickerData.years[row])"
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return pickerData.months.count
        case 1:
            return pickerData.years.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerData.month = pickerView.selectedRow(inComponent: 0) + 1
        pickerData.year = pickerData.years[pickerView.selectedRow(inComponent: 1)]
    }

}

struct MonthYearPickerData {
    let startYear: Int
    var months: [String] = []
    var month: Int!
    var years: [Int] = []
    var year: Int!

    static let yearRange = 95

    func yearToIndex(_ year: Int) -> Int {
        return year - startYear
    }

    init() {
        let currentYear = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
        startYear = currentYear - MonthYearPickerData.yearRange
        for year in startYear...currentYear {
            years.append(year)
        }
        self.year = currentYear
        // population months with localized names
        for month in 0...11 {
            months.append(DateFormatter().monthSymbols[month].capitalized)
        }
        self.month = 0
    }
}
