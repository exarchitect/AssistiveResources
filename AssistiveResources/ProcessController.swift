//
//  ProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/24/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol ProcessControllerResponseProtocol: class {
    func requestAction (command: Command)
}


class ProcessController: NSObject {
    
    var inUse: Bool = false
    weak var responseDelegate: ProcessControllerResponseProtocol!
    var primaryViewController: UIViewController? = nil
    weak var navigationController: UINavigationController!

    init (responseDelegate: ProcessControllerResponseProtocol, navController: UINavigationController) {
        self.responseDelegate = responseDelegate
        self.navigationController = navController
        self.inUse = true
        super.init()
    }
    
    func launch() {
        assert(self.primaryViewController != nil)
        self.navigationController.pushViewController(self.primaryViewController!, animated: false)
    }
    
    func terminate () {
        self.inUse = false
        
        self.navigationController.popViewController(animated: true)
        self.primaryViewController = nil;
    }
    
}


func instantiateViewController(storyboardName: String, storyboardID: String) -> UIViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
    return viewController
}
