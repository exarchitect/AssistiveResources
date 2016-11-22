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
    private var userModelController: UserModelController?
    
    
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
        self.userModelController = UserModelController()
        self.userModelController?.authorizeUser(completion: { (success) in
            if (success) {
                // launch the mainnav processcontroller
            } else {
                // launch the login processcontroller
            }
        })
    }
    
}
