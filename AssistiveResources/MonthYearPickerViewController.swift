//
//  MonthYearPickerViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 4/22/20.
//  Copyright © 2020 SevenPlusTwo. All rights reserved.
//

import UIKit

class MonthYearPickerViewController: UIViewController {

    @IBOutlet var pickerOutlet: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerOutlet = MonthYearPickerView()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


class MonthYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    var months: [String]!
    var years: [Int]!

    var month = Calendar.current.component(.month, from: Date()) {
        didSet {
            selectRow(month-1, inComponent: 0, animated: false)
        }
    }

    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            selectRow(years.index(of: year)!, inComponent: 1, animated: true)
        }
    }

    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.pickerSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.pickerSetup()
    }

    func pickerSetup() {
        // population years
        var years: [Int] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
            for _ in 1...15 {
                years.append(year)
                year += 1
            }
        }
        self.years = years

        // population months with localized names
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            months.append(DateFormatter().monthSymbols[month].capitalized)
            month += 1
        }
        self.months = months

        self.delegate = self
        self.dataSource = self

        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
        self.selectRow(currentMonth - 1, inComponent: 0, animated: false)
    }

    // Mark: UIPicker Delegate / Data Source

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = self.selectedRow(inComponent: 0)+1
        let year = years[self.selectedRow(inComponent: 1)]
        if let block = onDateSelected {
            block(month, year)
        }

        self.month = month
        self.year = year
    }

}
