//
//  AppController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/18/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class AppController: NSObject {

    var rootViewController: RootViewController!
    var navController: UINavigationController!
    var processControllerStack = [ProcessController]()
    
        
    func setupApplicationWindow() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        // create a root view controller
        self.rootViewController = instantiateViewController(storyboardName: "Main", storyboardID: "RootViewController")
        self.navController = UINavigationController(rootViewController: self.rootViewController)
        self.navController.setNavigationBarHidden(true, animated: false)

        window.rootViewController = self.navController
        window.makeKeyAndVisible()
        
        return window
    }
    
    final func start() {
        // make sure the rootvc draws before startup
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 0.1)) {
            self.internalStart()
        }
    }
    
    func internalStart() {
        fatalError("override \(#function)")
    }
    
    func checkDatabaseRefresh() {
        fatalError("override \(#function)")
    }
    
    
    // MARK: - Utilities
    
    func getTopProcessController () -> ProcessController? {
        if (self.processControllerStack.last != nil){
            return (self.processControllerStack.last)
        } else {
            return nil
        }
    }
    
//    func freeTopProcessController () {
//        if (self.processControllerStack.last != nil){
//            if (self.processControllerStack.last!.inUse == false) {
//                let _ = self.processControllerStack.popLast()
//            }
//        }
//    }
    
    func popTopProcessController () {
        let pController = self.processControllerStack.last
        //if (self.processControllerStack.last != nil){
        pController?.terminate()
        let _ = self.processControllerStack.popLast()
        //}
    }
    
}


