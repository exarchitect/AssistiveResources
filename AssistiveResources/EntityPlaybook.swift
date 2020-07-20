//
//  EntityPlaybook.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 4/8/20.
//  Copyright © 2020 SevenPlusTwo. All rights reserved.
//

import Foundation

protocol Identifiable {
    var name: String { get }
    var identifier: Int { get }
//    var type: EntityType { get }
}

typealias EntityDictionary = [String: Identifiable]

enum EntityType : Int {
    case organization, chapter, event, facility
}

struct EventDescriptor: Identifiable {
    var name: String
    var identifier: Int
    var type: EntityType {
        get {
            .event
        }
    }
}

struct OrganizationDescriptor: Identifiable {
    var name: String
    var identifier: Int
    var type: EntityType {
        get {
            .organization
        }
    }
}

struct ChapterDescriptor: Identifiable {
    var name: String
    var identifier: Int
    var type: EntityType {
        get {
            .chapter
        }
    }
}

struct FacilityDescriptor: Identifiable {
    var name: String
    var identifier: Int
    var type: EntityType {
        get {
            .facility
        }
    }
}

