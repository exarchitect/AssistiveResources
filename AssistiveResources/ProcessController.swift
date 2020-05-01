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
    var primaryViewController: UIViewController!

    required init?(services: SharedServices, handler: Commandable) {
        super.init()
        sharedServices = services
        commandHandler = handler
        guard let viewController = createPrimaryViewController() else {
            return nil
        }
        primaryViewController = viewController
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
