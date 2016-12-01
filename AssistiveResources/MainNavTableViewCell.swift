//
//  MainNavTableViewCell.swift
//  SwiftNeed
//
//  Created by Bill Johnson on 5/12/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

class MainNavTableViewCell: UITableViewCell {

    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(title: String, subTitle: String, imageName: String) {
        mainLabel.text = title
        detailLabel.text = subTitle
        leftImage.image = UIImage(named: imageName)
    }
    
}
