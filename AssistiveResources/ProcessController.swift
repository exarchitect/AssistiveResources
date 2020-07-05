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

    func createPrimaryViewController() -> UIViewController? {
        fatalError("override \(#function)")
    }
}

protocol ViewControllable: UIViewController {
    var parentProcessController: ProcessController? { get set }
    var userModel: User? { get }
    var resourcesModel: RegionalResourcesModelController? { get }
    func execute(command: AssistiveCommand)
}

extension ViewControllable {
    var userModel: User? {
        parentProcessController?.sharedServices.userModel
    }
    var resourcesModel: RegionalResourcesModelController? {
        parentProcessController?.sharedServices.regionalResources
    }
    func execute(command: AssistiveCommand){
        parentProcessController?.commandHandler.execute(command: command)
    }
}
