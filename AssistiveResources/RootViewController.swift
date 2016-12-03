//
//  RootViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/18/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

//    var appController: AppController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        self.appController = AppController.sharedInstance
//        self.appController?.start()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        freeMemory()
    }
    
}
