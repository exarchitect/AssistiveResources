//
//  NavigationPlaybook.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 5/12/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import Foundation


let updateNotificationKey = "notify_navigation_content_changed"


enum Destination : String {
    case Organizations, Events, Facilities, Travel, Inbox, Profile, News
}


struct DestinationDescriptor {
    var destination: Destination
    var title: String
    var subtitle: String
    var imageName: String
    
    init(dest: Destination,subtitle:String?=nil)
    {
        destination = dest
        var placeholderSubtitle:String

        switch dest {
        case Destination.Organizations:
            title = "Organizations/Services"
            placeholderSubtitle = "Locate services and groups for your needs"
            imageName = "organization"
        case Destination.Events:
            title = Destination.Events.rawValue
            placeholderSubtitle = "Regional and national events"
            imageName = "sports"
        case Destination.Facilities:
            title = "Accessibility"
            placeholderSubtitle = "Find restrooms and other family-friendly facilities near you"
            imageName = "venues"
        case Destination.Travel:
            title = Destination.Travel.rawValue
            placeholderSubtitle = "Resources for vacations and travel within the US"
            imageName = "travel"
        case Destination.Inbox:
            title = Destination.Inbox.rawValue
            placeholderSubtitle = "Your messages"
            imageName = "inbox"
        case Destination.Profile:
            title = Destination.Profile.rawValue
            placeholderSubtitle = "Tell us about yourself so we can recommend resources"
            imageName = "favourite2"
        case Destination.News:
            title = Destination.News.rawValue
            placeholderSubtitle = "Online articles and news"
            imageName = "rss"
        }
        
        if let _subtitle = subtitle {
            self.subtitle = _subtitle
        } else {
            self.subtitle = placeholderSubtitle
        }
    }
}
