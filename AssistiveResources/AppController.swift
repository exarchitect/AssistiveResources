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
    
}

// MARK: - utilities

func instantiateViewController<T>(storyboardName: String, storyboardID: String) -> T? {
    let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
    return viewController as? T
}
