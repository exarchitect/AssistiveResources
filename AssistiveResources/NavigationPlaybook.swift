//
//  NavigationPlaybook.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 5/12/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import Foundation



enum NavigationCategory : String {
    case organizations, events, facilities, travel, inbox, profile, news
}


class NavigationCategories: NSObject {
    
    private var navigationArray:[DestinationDescriptor] = []

    var count: Int {
        return navigationArray.count
    }
    
    subscript(pos: Int) -> DestinationDescriptor {
        return navigationArray[pos]
    }
    
    override init() {
        super.init()

        navigationArray.append(DestinationDescriptor(dest: NavigationCategory.events))
        navigationArray.append(DestinationDescriptor(dest: NavigationCategory.organizations))
        navigationArray.append(DestinationDescriptor(dest: NavigationCategory.facilities))
        navigationArray.append(DestinationDescriptor(dest: NavigationCategory.travel))
        navigationArray.append(DestinationDescriptor(dest: NavigationCategory.news))
        navigationArray.append(DestinationDescriptor(dest: NavigationCategory.inbox))
        navigationArray.append(DestinationDescriptor(dest: NavigationCategory.profile))
    }
    
    func updateSubtitles() {
        var index = 0
        for item in navigationArray {
            switch item.destination {
            case NavigationCategory.organizations:
                let _ = 8
                //navigationArray[index].subtitle = "Hi MOM!"
                
            case NavigationCategory.events:
                navigationArray[index].subtitle = NSLocalizedString("Upcoming events across the nation and in your area", comment: "subtext for event nav item")
                
            case NavigationCategory.facilities:
                let _ = 8
                
            case NavigationCategory.travel:
                let _ = 8
                
            case NavigationCategory.news:
                let _ = 8
                
            case NavigationCategory.inbox:
                let msgs = 3
                var msgString = "no"
                if (msgs > 0) {
                    msgString = "\(msgs)"
                }
                let prefix = NSLocalizedString("You have ", comment: "You have....")
                let suffix = NSLocalizedString(" unread messages", comment: "...unread messages")
                navigationArray[index].subtitle = prefix + msgString + suffix
                
            case NavigationCategory.profile:
                let _ = 8
            }
            
            index = index + 1
        }
    }
}
    
struct DestinationDescriptor {
    var destination: NavigationCategory
    var title: String
    var subtitle: String
    var imageName: String
    
    init(dest: NavigationCategory, customSubtitle: String? = nil)
    {
        destination = dest
        var genericSubtitle:String
        
        switch dest {
        case .organizations:
            title = "Organizations/Services"
            genericSubtitle = "Locate services and groups for your needs"
            imageName = "organization"
        case .events:
            title = "Events"
            genericSubtitle = "Regional and national events"
            imageName = "sports"
        case .facilities:
            title = "Accessibility"
            genericSubtitle = "Find restrooms and other family-friendly facilities"
            imageName = "venues"
        case .travel:
            title = "Travel"
            genericSubtitle = "Resources for vacations and travel within the US"
            imageName = "travel"
        case .inbox:
            title = "Inbox"
            genericSubtitle = "Your messages"
            imageName = "inbox"
        case .profile:
            title = "Profile"
            genericSubtitle = "Tell us about yourself"
            imageName = "favourite2"
        case .news:
            title = "News"
            genericSubtitle = "Online articles and news for the special needs community"
            imageName = "rss"
        }
        guard let custom = customSubtitle else {
            subtitle = genericSubtitle
            return
        }
        subtitle = custom
    }
}

