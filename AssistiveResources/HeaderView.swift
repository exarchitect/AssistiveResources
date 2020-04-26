//
//  HeaderView.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/7/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


var view: HeaderView!

class HeaderView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var view: UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let view: UIView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
}
