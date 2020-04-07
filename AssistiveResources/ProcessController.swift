//
//  ProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/24/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


class ProcessController: NSObject, CommandResponseProtocol {

    var sharedServices: SharedServices!      // TODO: should this be weak?
    weak var commandHandler: CommandResponseProtocol!
    private var primaryProcessViewController: ProcessViewController? = nil      // TODO: should this be weak?

    required override init(){
        super.init()
    }

    func setup (responseDelegate: CommandResponseProtocol, services: SharedServices) {
        self.commandHandler = responseDelegate
        self.sharedServices = services
    }

    func terminate (navController: UINavigationController) {
        navController.popViewController(animated: true)
        self.primaryProcessViewController = nil;
    }

    final func invokeAction (command: AssistiveCommand){
        self.commandHandler.invokeAction(command: command)
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

