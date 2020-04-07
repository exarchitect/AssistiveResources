//
//  AssistiveCommand.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/15/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import Foundation


protocol CommandResponseProtocol: class {
    func invokeAction (command: AssistiveCommand)
}


struct AssistiveCommand {
    enum CommandType {
        case dismissTopProcessController
        case requestUserIdentity
        case userSuccessfullyIdentified
        case navigateTo(destination:NavigationCategory)
        case eventSelected(event: EntityDescriptor)
        case organizationSelected(organization: EntityDescriptor)
    }
    let type: CommandType
}


