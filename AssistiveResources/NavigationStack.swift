//
//  NavigationStack.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 4/6/20.
//  Copyright © 2020 SevenPlusTwo. All rights reserved.
//

import UIKit

class NavigationStack: NSObject, CommandResponseProtocol {

    var processControllerStack = [ProcessController]()
    var services: SharedServices!      // TODO: should this be weak?
    var navController: UINavigationController

    init(services: SharedServices, navController: UINavigationController) {
        self.services = services
        self.navController = navController
    }

    @discardableResult func instantiateProcess<T: ProcessController>(ofType: T.Type) -> T? {
        var viewController: UIViewController?

        let processController = T.init()

        switch ofType {
        case is NavListProcessController.Type:
            let navListViewController: NavListViewController? = instantiateViewController(storyboardName: "NavList", storyboardID: "navListStoryboardID")
            navListViewController?.configuration()
            viewController = navListViewController

        case is AuthenticationProcessController.Type:
            viewController = instantiateViewController(storyboardName: "AuthenticationProcess", storyboardID: "LoginStoryboardID")

        case is EventListProcessController.Type:
            viewController = instantiateViewController(storyboardName: "EventList", storyboardID: "EventListStoryboardID")

        case is EventDetailProcessController.Type:
            viewController = instantiateViewController(storyboardName: "EventDetailStoryboard", storyboardID: "EventDetailStoryboardID")

        case is OrganizationListProcessController.Type:
            viewController = instantiateViewController(storyboardName: "OrganizationList", storyboardID: "OrganizationListStoryboardID")

        default:
            fatalError("override \(#function)")
        }
        guard let processViewController = viewController as? ProcessViewController else {
            return nil
        }

        processController.setup(responseDelegate: self, services: services)
        processController.commandHandler = self
        processControllerStack.append(processController)

        processViewController.processController = processController
        navController.pushViewController(processViewController, animated: false)

        return processController
    }

    // MARK: - CommandResponseProtocol

    func invokeAction(command: AssistiveCommand) {

        switch command.type {

        case .dismissTopProcessController:
            guard let pController = processControllerStack.last else {
                return
            }
            pController.terminate(navController: navController)
            let _ = processControllerStack.popLast()

        case .requestUserIdentity:
            instantiateProcess(ofType: AuthenticationProcessController.self)

        case .userSuccessfullyIdentified:
            if (services.regionalResourcesModelController == nil) {
                let online = true       // TODO: implement
                services.regionalResourcesModelController = RegionalResourcesModelController(atLocation: services.userModel.locationProfile, isOnline: online)
                services.regionalResourcesModelController?.initiateLoading()
            }
            requestMainNavigationRefresh()

        case .navigateTo(let destination):
            //print(" -- navigate to: \(destination.rawValue)")
            switch destination {
            case .Organizations:
                instantiateProcess(ofType: OrganizationListProcessController.self)

            case .Events:
                instantiateProcess(ofType: EventListProcessController.self)

            case .Facilities:
                let _ = 7

            case .Travel:
                let _ = 7

            case .News:
                let _ = 7

            case .Inbox:
                let _ = 7

            case .Profile:
                // temp for testing
                services.userModel.logout()
                instantiateProcess(ofType: AuthenticationProcessController.self)
}

        case .eventSelected(let event):
            guard let eventDetailProcessController = instantiateProcess(ofType: EventDetailProcessController.self) else {
                return
            }
            eventDetailProcessController.filter = EntityDescriptor(event)

        case .organizationSelected(let organization):
            _ = organization.entityID
        }
    }

}
