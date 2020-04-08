//
//  EventListTableViewCell.swift
//  SwiftNeed
//
//  Created by Bill Johnson on 5/17/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

class EventListTableViewCell: UITableViewCell {

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var eventDetailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var sponsorLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayOfMonthLabel: UILabel!
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(event: StoredEvent, expand: Bool) {
        mainTitle.text = event.eventTitle
        eventDetailLabel.text = event.eventDescriptionBrief
        let sponsorPrefix = NSLocalizedString("Sponsored by ", comment: "Sponsored by....")
        sponsorLabel.text = sponsorPrefix + event.organizationTitle
        locationLabel.text = event.facilityTitle
        dateTimeLabel.text = event.timeBlock!.whenDescription
        
        monthLabel.text = event.timeBlock!.month3Char
        dayOfMonthLabel.text = "\(event.timeBlock!.day)"
        dayOfWeekLabel.text = event.timeBlock!.dayOfWeek
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        if expand {
            self.backgroundColor = UIColor.lightText
        } else {
            self.backgroundColor = UIColor.white
        }
    }

    @IBAction func showDetailButtonAction(_ sender: UIButton) {
        
    }
    
}
