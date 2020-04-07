//
//  ProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/24/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class ProcessController: NSObject, Commandable {

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

    final func execute(command: AssistiveCommand){
        self.commandHandler.execute(command: command)
    }
}


// MARK: - Navigable PROTOCOL

//protocol Navigable where Self: UIViewController {
//    var processController: ProcessController { get set }
//    func createProcessControllerType()
//    static var storyboardName: String { get }
//    static var storyboardID: String { get }
//}
//
//extension Navigable {
//
//    static func launchProcessViewController<T>(type: T.Type, with services: SharedServices, navigationController: UINavigationController) {
//        let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID) as? T
//        // config vc
//
//        let pc = processControllerType()
//
//
//        navigationController.pushViewController(viewController, animated: false)
//    }
//}

