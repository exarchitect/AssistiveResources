//
//  AppController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/18/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

final class AppController: NSObject {

    private var rootViewController: RootViewController!
    
    var username: String = ""
    
    override init() {
        //?

        super.init()
    }
    
    func setup() -> UIWindow {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
        
        window.rootViewController = self.rootViewController
        
        window.makeKeyAndVisible()
        
        return window
    }
    
    func start()  {
        
        // instantiate user modelcontroller (which instantiates the user model)
        // have authenticated user?  (if no auth user but have creds, attempt to authenticate)
            // authenticated -> launch the mainnav processcontroller
            // NOT authenticated -> launch the login processcontroller {closure -> launch mainnav processcontroller on return}
    }
    
}
