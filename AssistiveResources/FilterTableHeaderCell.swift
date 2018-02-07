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
    
    func setCellSubhead (text: String = "none selected") {
        self.subheadLabelOutlet.text = text
        if (text == "select one" || text == "none selected" || text == "not set") {
            self.subheadLabelOutlet.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightThin)
            self.subheadLabelOutlet.textColor = UIColor.lightGray
        } else {
            self.subheadLabelOutlet.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular)
            self.subheadLabelOutlet.textColor = UIColor.darkText
        }

    }

}
