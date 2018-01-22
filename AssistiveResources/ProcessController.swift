//
//  ProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/24/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol ProcessControllerResponseProtocol: class {
    func requestAction (command: AssistiveCommand)
}


class ProcessController: NSObject {
    
    weak var responseDelegate: ProcessControllerResponseProtocol!
    var sharedServices: SharedServices!
    var primaryViewController: ProcessViewController? = nil
    weak var navigationController: UINavigationController!

    var inUse: Bool {
        get {
            return primaryViewController != nil
        }
    }

    init (responseDelegate: ProcessControllerResponseProtocol, navController: UINavigationController, services: SharedServices) {
        self.responseDelegate = responseDelegate
        self.navigationController = navController
        self.sharedServices = services
        super.init()
    }
    
    func createViewController() -> ProcessViewController? {
        fatalError("override \(#function)")
    }
    
    func launch() {
        self.primaryViewController = self.createViewController()
        self.primaryViewController?.commandDelegate = self.responseDelegate
        assert(self.primaryViewController != nil)
        self.navigationController.pushViewController(self.primaryViewController!, animated: false)
    }
    
    func terminate () {
        
        self.navigationController.popViewController(animated: true)
        self.primaryViewController = nil;
    }
    
}


// MARK: - utilities

func instantiateViewController<T>(storyboardName: String, storyboardID: String) -> T? {
    let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
    return viewController as? T
}

