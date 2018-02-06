//
//  FilterTableViewCellHeader.swift
//  AssistiveResources
//
//  Created by WCJ on 2/5/18.
//  Copyright © 2018 SevenPlusTwo. All rights reserved.
//

import UIKit

class FilterTableViewCellHeader: UITableViewCell {

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

}
