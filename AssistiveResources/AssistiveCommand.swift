//
//  AssistiveCommand.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/15/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import Foundation


protocol Commandable: class {
    func execute (command: AssistiveCommand)
}


enum AssistiveCommand {
    case dismissCurrentProcess
    case requestUserIdentity
    case userSuccessfullyIdentified
    case navigateTo(_ destination: NavigationCategory)
    case showEventDetail(_ event: EventDescriptor)
    case showOrganizationDetail(_ organization: OrganizationDescriptor)
}
