//
//  EntityPlaybook.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 4/8/20.
//  Copyright © 2020 SevenPlusTwo. All rights reserved.
//

import Foundation

class ResourceEntityDescriptor {
    var name: String
    var identifier: Int
    var type: EntityType!

    enum EntityType : Int {
        case Organization, Chapter, Event, Facility
    }

    init(name: String, identifier: Int) {
        self.name = name
        self.identifier = identifier
    }
}

class EventDescriptor: ResourceEntityDescriptor {
    override init(name: String, identifier: Int) {
        super.init(name: name, identifier: identifier)
        self.type = .Event
    }
}

class OrganizationDescriptor: ResourceEntityDescriptor {
    override init(name: String, identifier: Int) {
        super.init(name: name, identifier: identifier)
        self.type = .Organization
    }
}

class ChapterDescriptor: ResourceEntityDescriptor {
    override init(name: String, identifier: Int) {
        super.init(name: name, identifier: identifier)
        self.type = .Chapter
    }
}

class FacilityDescriptor: ResourceEntityDescriptor {
    override init(name: String, identifier: Int) {
        super.init(name: name, identifier: identifier)
        self.type = .Facility
    }
}

