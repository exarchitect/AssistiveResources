//
//  AssistiveCommand.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 1/15/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import Foundation


struct AssistiveCommand {
    enum CommandType {
        case dismissProcessController
        case userIdentified
        case identifyUser
        case navigateTo(destination:NavigationCategory)
        case eventSelected(event: EntityDescriptor)
        case organizationSelected(organization: EntityDescriptor)
    }
    let type: CommandType
}


