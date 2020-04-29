//
//  ProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/24/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class ProcessController: NSObject {

    var sharedServices: SharedServices!
    weak var commandHandler: Commandable!
    weak var primaryViewController: UIViewController?

    required override init(){
        super.init()
    }

    func setup(commandHandler: Commandable, services: SharedServices, primaryViewController: UIViewController) {
        self.commandHandler = commandHandler
        self.sharedServices = services
        self.primaryViewController = primaryViewController
    }

    func terminate(navController: UINavigationController, previousTopViewController: UIViewController) {
        navController.popToViewController(previousTopViewController, animated: true)
        self.primaryViewController = nil;
    }

    final func executeCommand(_ command: AssistiveCommand){
        self.commandHandler.execute(command: command)
    }

    func createPrimaryViewController() -> UIViewController? {
        fatalError("override \(#function)")
    }
}
