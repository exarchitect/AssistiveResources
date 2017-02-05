//
//  OrganizationListTableViewCell.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/4/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit

class OrganizationListTableViewCell: UITableViewCell {

    @IBOutlet weak var organizationTitle: UILabel!
    @IBOutlet weak var mission: UILabel!
    @IBOutlet weak var geographicScope: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(org: Organization, expand: Bool) {
        self.organizationTitle.text = org.organizationTitle
        self.mission.text = org.mission
        self.geographicScope.text = org.geographicScope
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        if expand {
            self.backgroundColor = UIColor.groupTableViewBackground
        } else {
            self.backgroundColor = UIColor.white
        }
    }

}
