//
//  ProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/24/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol ProcessControllerProtocol: class {
    func navigationController () -> UINavigationController
    func requestAction (command: Command)

//    func dismissProcessController (controller: ProcessController)
}


class ProcessController: NSObject {
    
    var inUse: Bool = false
    weak var responseDelegate: ProcessControllerProtocol!

    init (responseDelegate: ProcessControllerProtocol) {
        
        self.responseDelegate = responseDelegate
        self.inUse = true
        super.init()
    }
    
//    override init() {
//        self.inUse = true
//        super.init()
//    }

    func terminate () {
        self.inUse = false
    }
    
    func launch() -> Bool {
        return true
    }
    
}


func instantiateViewController(storyboardName: String, storyboardID: String) -> UIViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
    return viewController
}
