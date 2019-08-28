//
//  NavigationPlaybook.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 5/12/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import Foundation



enum NavigationCategory : String {
    case Organizations, Events, Facilities, Travel, Inbox, Profile, News
}


class NavigationContent: NSObject {
    
    private var navigationArray:[DestinationDescriptor] = []

    var count: Int {
        return navigationArray.count
    }
    
    subscript(pos: Int) -> DestinationDescriptor {
        return navigationArray[pos]
    }
    
    override init() {
        super.init()

        navigationArray.append(DestinationDescriptor(dest: NavigationCategory.Organizations))
        navigationArray.append(DestinationDescriptor(dest: NavigationCategory.Events))
        navigationArray.append(DestinationDescriptor(dest: NavigationCategory.Facilities))
        navigationArray.append(DestinationDescriptor(dest: NavigationCategory.Travel))
        navigationArray.append(DestinationDescriptor(dest: NavigationCategory.News))
        navigationArray.append(DestinationDescriptor(dest: NavigationCategory.Inbox))
        navigationArray.append(DestinationDescriptor(dest: NavigationCategory.Profile))
    }
    
    func updateSubtitles() {
        var index = 0
        for item in navigationArray {
            switch item.destination {
            case NavigationCategory.Organizations:
                let _ = 8
                //navigationArray[index].subtitle = "Hi MOM!"
                
            case NavigationCategory.Events:
                navigationArray[index].subtitle = NSLocalizedString("Regional and national events in your area", comment: "subtext for event nav item")
                
            case NavigationCategory.Facilities:
                let _ = 8
                
            case NavigationCategory.Travel:
                let _ = 8
                
            case NavigationCategory.News:
                let _ = 8
                
            case NavigationCategory.Inbox:
                let msgs = 3
                var msgString = "no"
                if (msgs > 0) {
                    msgString = "\(msgs)"
                }
                let prefix = NSLocalizedString("You have ", comment: "You have....")
                let suffix = NSLocalizedString(" unread messages", comment: "...unread messages")
                navigationArray[index].subtitle = prefix + msgString + suffix
                
            case NavigationCategory.Profile:
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
    
    init(dest: NavigationCategory,subtitle:String?=nil)
    {
        destination = dest
        var placeholderSubtitle:String
        
        switch dest {
        case .Organizations:
            title = "Organizations/Services"
            placeholderSubtitle = "Locate services and groups for your needs"
            imageName = "organization"
        case .Events:
            title = NavigationCategory.Events.rawValue
            placeholderSubtitle = "Regional and national events"
            imageName = "sports"
        case .Facilities:
            title = "Accessibility"
            placeholderSubtitle = "Find restrooms and other family-friendly facilities"
            imageName = "venues"
        case .Travel:
            title = NavigationCategory.Travel.rawValue
            placeholderSubtitle = "Resources for vacations and travel within the US"
            imageName = "travel"
        case .Inbox:
            title = NavigationCategory.Inbox.rawValue
            placeholderSubtitle = "Your messages"
            imageName = "inbox"
        case .Profile:
            title = NavigationCategory.Profile.rawValue
            placeholderSubtitle = "Tell us about yourself"
            imageName = "favourite2"
        case .News:
            title = NavigationCategory.News.rawValue
            placeholderSubtitle = "Online articles and news for the special needs community"
            imageName = "rss"
        }
        
        if let _subtitle = subtitle {
            self.subtitle = _subtitle
        } else {
            self.subtitle = placeholderSubtitle
        }
    }
}

