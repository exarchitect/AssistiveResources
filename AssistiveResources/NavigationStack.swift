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
    var services: SharedServices!
    weak var navController: UINavigationController!

    init(services: SharedServices, navController: UINavigationController) {
        self.services = services
        self.navController = navController
    }

    @discardableResult func launchProcess<T: ProcessController>(_ ofType: T.Type, animated: Bool) -> T? {
        guard let processController = T.init(services: services, handler: self) else {
            return nil
        }
        processControllerStack.append(processController)
        navController.pushViewController(processController.primaryViewController, animated: animated)

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
            launchProcess(AuthenticationProcessController.self, animated: false)

        case .userSuccessfullyIdentified:
            services?.loadRepository()
            requestMainNavigationRefresh()

        case .navigateTo(let destination):
            switch destination {
            case .organizations:
                launchProcess(OrganizationListProcessController.self, animated: true)

            case .events:
                launchProcess(EventListProcessController.self, animated: true)

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
                launchProcess(AuthenticationProcessController.self, animated: true)
            }

        case .showEventDetail(let event):
            services.selections.currentEvent = event.identifier
            launchProcess(EventDetailProcessController.self, animated: true)

        case .showOrganizationDetail(let organization):
            services.selections.currentOrganization = organization.identifier
            launchProcess(OrganizationDetailProcessController.self, animated: true)
        }
    }
}
