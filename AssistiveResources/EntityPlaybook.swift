//
//  EntityPlaybook.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 4/8/20.
//  Copyright © 2020 SevenPlusTwo. All rights reserved.
//

import Foundation

enum EntityType : Int {
    case organization, chapter, event, facility
}

protocol Describable {
    var name: String { get set }
    var identifier: Int { get set }
    var type: EntityType { get }
    init(name: String, identifier: Int)
}

extension Describable {
    init(name: String, identifier: Int) {
        self.init(name: name, identifier: identifier)
    }
}

struct EventDescriptor: Describable {
    var name: String
    var identifier: Int
    var type: EntityType {
        get {
            .event
        }
    }
}

struct OrganizationDescriptor: Describable {
    var name: String
    var identifier: Int
    var type: EntityType {
        get {
            .organization
        }
    }
}

struct ChapterDescriptor: Describable {
    var name: String
    var identifier: Int
    var type: EntityType {
        get {
            .chapter
        }
    }
}

struct FacilityDescriptor: Describable {
    var name: String
    var identifier: Int
    var type: EntityType {
        get {
            .facility
        }
    }
}

