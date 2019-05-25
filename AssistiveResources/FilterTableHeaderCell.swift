//
//  FilterTableViewCellHeader.swift
//  AssistiveResources
//
//  Created by WCJ on 2/5/18.
//  Copyright © 2018 SevenPlusTwo. All rights reserved.
//

import UIKit

class FilterTableHeaderCell: UITableViewCell {

    @IBOutlet weak var headerLabelOutlet: UILabel!
    @IBOutlet weak var subheadLabelOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure (mainText: String, headerEnabled: Bool, subText: String, subTextEnabled: Bool) {
        headerLabelOutlet.text = mainText
        if headerEnabled {
            headerLabelOutlet.textColor = UIColor.darkText
        } else {
            headerLabelOutlet.textColor = UIColor.lightGray
        }
        backgroundColor = UIColor.groupTableViewBackground

        self.subheadLabelOutlet.text = subText
        if subTextEnabled {
            self.subheadLabelOutlet.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
            self.subheadLabelOutlet.textColor = UIColor.darkText
        } else {
            self.subheadLabelOutlet.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.thin)
            self.subheadLabelOutlet.textColor = UIColor.lightGray
        }
    }
}
