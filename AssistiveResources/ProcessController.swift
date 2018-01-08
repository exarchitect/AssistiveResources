//
//  ProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/24/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol ProcessControllerResponseHandler: class {
    //func navigationController () -> UINavigationController
    func requestAction (command: Command)
}


class ProcessController: NSObject {
    
    var inUse: Bool = false
    weak var responseDelegate: ProcessControllerResponseHandler!
    weak var primaryViewController: UIViewController? = nil
    weak var navigationController: UINavigationController!

    init (responseDelegate: ProcessControllerResponseHandler, navController: UINavigationController) {
        
        self.responseDelegate = responseDelegate
        self.navigationController = navController
        self.inUse = true
        super.init()
    }
    
    func launch() -> Bool {
        return true
    }
    
    func terminate () {
        self.inUse = false
    }
    
}


func instantiateViewController(storyboardName: String, storyboardID: String) -> UIViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
    return viewController
}
