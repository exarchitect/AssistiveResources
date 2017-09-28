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

    init (responseDelegate: ProcessControllerResponseHandler) {
        
        self.responseDelegate = responseDelegate
        self.inUse = true
        super.init()
    }
    
    func terminate (navController: UINavigationController) {
        self.inUse = false
    }
    
    func launch(navController: UINavigationController) -> Bool {
        return true
    }
    
}


func instantiateViewController(storyboardName: String, storyboardID: String) -> UIViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
    return viewController
}
