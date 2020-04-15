//
//  FilterTableRowCell.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/6/18.
//  Copyright © 2018 SevenPlusTwo. All rights reserved.
//

import UIKit

class FilterTableRowCell: UITableViewCell {

    @IBOutlet weak var checkmarkImageOutlet: UIImageView!
    @IBOutlet weak var titleLabelOutlet: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure (text: String, isChecked: Bool) {
        checkmarkImageOutlet.isHidden = !isChecked
        backgroundColor = UIColor.white
        titleLabelOutlet.text = text
    }
}
