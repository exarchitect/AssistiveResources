//
//  AppController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/18/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

class AppController: NSObject {

    private var rootViewController: RootViewController!
    private var topProcessController: ProcessController!
    
    private var userModelController: UserModelController!
    private var resourcesModelController : ResourcesModelController
    
    var username: String = ""
    
    override init() {
        
        initializeDatabase()
        self.userModelController = UserModelController()
        self.resourcesModelController = ResourcesModelController()
        
        super.init()
    }
    
    func setup() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        // create a root view controller as a backdrop for all other view controllers
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
        window.rootViewController = self.rootViewController
        window.makeKeyAndVisible()
        
        return window
    }
    
    func start()  {
        
        // temp
        //self.userModelController?.storeUserCredentials(username: "exarchitect@gmail.com", password: "serveme1")

        self.userModelController?.authorizeUser(completion: { (success) in
            if (success) {
                print("logged in")
                // launch the mainnav processcontroller
            } else {
                print("NOT logged in")
                // launch the login processcontroller
            }
        })
    }
}


func displayViewController(storyboardName: String, storyboardID: String, onTopOf: UIViewController) {
    let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
    onTopOf.present(viewController, animated: true, completion: nil)
}
