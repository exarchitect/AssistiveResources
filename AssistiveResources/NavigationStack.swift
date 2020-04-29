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

    @discardableResult func launchProcess<T: ProcessController>(ofType: T.Type, animated: Bool) -> T? {
        let processController = T.init()
        let viewController = processController.createPrimaryViewController()

        guard let processViewController = viewController, let services = services else {
            return nil
        }
        processController.setup(commandHandler: self, services: services, primaryViewController: processViewController)
        processController.commandHandler = self
        processControllerStack.append(processController)

        navController.pushViewController(processViewController, animated: animated)

        return processController
    }

    // MARK: - Commandable Protocol

    func execute(command: AssistiveCommand) {

        switch command {
        case .dismissCurrentProcess:
            guard let currentProcessController = processControllerStack.popLast(), let previousViewController = processControllerStack.last?.primaryViewController else {
                return
            }
            currentProcessController.terminate(navController: navController, previousTopViewController: previousViewController)

        case .requestUserIdentity:
            launchProcess(ofType: AuthenticationProcessController.self, animated: false)

        case .userSuccessfullyIdentified:
            services?.loadRepositoryIfNeeded()
            requestMainNavigationRefresh()

        case .navigateTo(let destination):
            switch destination {
            case .organizations:
                launchProcess(ofType: OrganizationListProcessController.self, animated: true)

            case .events:
                launchProcess(ofType: EventListProcessController.self, animated: true)

            case .facilities:
                let _ = 7

            case .travel:
                let _ = 7

            case .news:
                let _ = 7

            case .inbox:
                let _ = 7

            case .profile:
                // temp for testing
                services?.userModel.logout()
                launchProcess(ofType: AuthenticationProcessController.self, animated: true)
            }

        case .showEventDetail(let event):
            guard let eventDetailProcessController = launchProcess(ofType: EventDetailProcessController.self, animated: true) else {
                return
            }
            eventDetailProcessController.event = event

        case .showOrganizationDetail(let organization):
//            _ = organization.identifier
            guard let eventDetailProcessController = launchProcess(ofType: EventDetailProcessController.self, animated: true) else {
                return
            }
            eventDetailProcessController.event = EventDescriptor(name: "TestOrg", identifier: 235)
        }
    }
}
