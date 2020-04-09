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
    weak var primaryProcessViewController: ProcessViewController?

    required override init(){
        super.init()
    }

    func setup(commandHandler: Commandable, services: SharedServices, primaryViewController: ProcessViewController) {
        self.commandHandler = commandHandler
        self.sharedServices = services
        self.primaryProcessViewController = primaryViewController
    }

    func terminate(navController: UINavigationController, previousTopViewController: UIViewController) {
        navController.popToViewController(previousTopViewController, animated: true)
        self.primaryProcessViewController = nil;
    }

    final func executeCommand(_ command: AssistiveCommand){
        self.commandHandler.execute(command: command)
    }

    func createPrimaryViewController() -> ProcessViewController? {
        fatalError("override \(#function)")
    }
}
