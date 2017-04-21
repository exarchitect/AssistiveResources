//
//  AppController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/18/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class AppController: NSObject, ProcessControllerProtocol {

    var rootViewController: RootViewController!
    var navController: UINavigationController!
    var processControllerStack = [ProcessController]()
    
    
    override init() {
        super.init()
    }
    
    
    func setupApplicationWindow() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        // create a root view controller
        self.rootViewController = instantiateViewController(storyboardName: "Main", storyboardID: "RootViewController") as! RootViewController
        self.navController = UINavigationController(rootViewController: self.rootViewController)
        self.navController.setNavigationBarHidden(true, animated: false)

        window.rootViewController = self.navController
        window.makeKeyAndVisible()
        
        return window
    }
    
    func start() {
        // override in subclass
    }
    
    func checkDatabaseRefresh() {
        // override in subclass
    }
    
    
    // MARK: - ProcessControllerProtocol

    func navigationController () -> UINavigationController {
        return self.navController
    }
    
    func requestAction(command: Command) {
        
    }
    

    // MARK: - Utilities
    
    func freeTopProcessController () {
        if (self.processControllerStack.last != nil){
            if (!self.processControllerStack.last!.inUse) {
                let _ = self.processControllerStack.popLast()
            }
        }
    }
    
}


