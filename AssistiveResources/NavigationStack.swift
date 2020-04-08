//
//  NavigationStack.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 4/6/20.
//  Copyright © 2020 SevenPlusTwo. All rights reserved.
//

import UIKit

class NavigationStack: NSObject, Commandable {

    var processControllerStack = [ProcessController]()
    var services: SharedServices?
    weak var navController: UINavigationController!

    init(services: SharedServices, navController: UINavigationController) {
        self.services = services
        self.navController = navController
    }

    @discardableResult func instantiateProcess<T: ProcessController>(ofType: T.Type) -> T? {
        let processController = T.init()
        let viewController = processController.createPrimaryViewController()

        guard let processViewController = viewController, let services = services else {
            return nil
        }
        processController.setup(commandHandler: self, services: services, primaryViewController: processViewController)
        processController.commandHandler = self
        processControllerStack.append(processController)

        processViewController.processController = processController
        navController.pushViewController(processViewController, animated: false)

        return processController
    }

    // MARK: - Commandable Protocol

    func execute(command: AssistiveCommand) {

        switch command {
        case .dismissCurrentProcess:
            guard let pController = processControllerStack.popLast(), let previousViewController = processControllerStack.last?.primaryProcessViewController else {
                return
            }
            pController.terminate(navController: navController, previousTopViewController: previousViewController)

        case .requestUserIdentity:
            instantiateProcess(ofType: AuthenticationProcessController.self)

        case .userSuccessfullyIdentified:
            services?.loadRepositoryIfNeeded()
            requestMainNavigationRefresh()

        case .selectCategory(let destination):
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
                services?.userModel.logout()
                instantiateProcess(ofType: AuthenticationProcessController.self)
            }

        case .selectEvent(let event):
            guard let eventDetailProcessController = instantiateProcess(ofType: EventDetailProcessController.self) else {
                return
            }
            eventDetailProcessController.filter = event

        case .selectOrganization(let organization):
            _ = organization.identifier
        }
    }

}
