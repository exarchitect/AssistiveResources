//
//  ProcessController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 11/24/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


protocol CommandActionProtocol: class {
    func requestAction (command: AssistiveCommand)
}


class ProcessController: NSObject, Navigable, CommandActionProtocol {
    
    var sharedServices: SharedServices!
    private weak var responseDelegate: CommandActionProtocol!
    private var primaryProcessViewController: ProcessViewController? = nil
    private weak var navigationController: UINavigationController!

    var inUse: Bool {
        get {
            return primaryProcessViewController != nil
        }
    }

    required override init(){
        super.init()
    }

    func setup (responseDelegate: CommandActionProtocol, navController: UINavigationController, services: SharedServices) {
        self.responseDelegate = responseDelegate
        self.navigationController = navController
        self.sharedServices = services
    }
    
    func createPrimaryViewController() -> ProcessViewController? {
        fatalError("override \(#function)")
    }
    
    func launch() {
        self.primaryProcessViewController = self.createPrimaryViewController()
        self.primaryProcessViewController?.setupDelegate(selectorDelegate: self.responseDelegate)
        assert(self.primaryProcessViewController != nil)
        self.navigationController.pushViewController(self.primaryProcessViewController!, animated: false)
    }
    
    func terminate () {
        
        self.navigationController.popViewController(animated: true)
        self.primaryProcessViewController = nil;
    }
    
    func requestAction (command: AssistiveCommand){
        self.responseDelegate.requestAction(command: command)
    }
}


// MARK: - utilities

func instantiateViewController<T>(storyboardName: String, storyboardID: String) -> T? {
    let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
    return viewController as? T
}


protocol Navigable {
    func setup (responseDelegate: CommandActionProtocol, navController: UINavigationController, services: SharedServices)
    func launch()
    func terminate()
}


