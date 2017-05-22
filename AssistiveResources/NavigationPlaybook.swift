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
        self.initilizeNavigation()
    }
    
    func initilizeNavigation() {
        
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
                //if self.usrModelController != nil {
                    navigationArray[index].subtitle = "Regional and national events in your area"
                //}
                
            case NavigationCategory.Facilities:
                let _ = 8
                
            case NavigationCategory.Travel:
                let _ = 8
                
            case NavigationCategory.News:
                let _ = 8
                
            case NavigationCategory.Inbox:
                //if self.usrModelController != nil {
                    navigationArray[index].subtitle = "You have 3 unread messages"
                //}
                
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
            case NavigationCategory.Organizations:
                title = "Organizations/Services"
                placeholderSubtitle = "Locate services and groups for your needs"
                imageName = "organization"
            case NavigationCategory.Events:
                title = NavigationCategory.Events.rawValue
                placeholderSubtitle = "Regional and national events"
                imageName = "sports"
            case NavigationCategory.Facilities:
                title = "Accessibility"
                placeholderSubtitle = "Find restrooms and other family-friendly facilities"
                imageName = "venues"
            case NavigationCategory.Travel:
                title = NavigationCategory.Travel.rawValue
                placeholderSubtitle = "Resources for vacations and travel within the US"
                imageName = "travel"
            case NavigationCategory.Inbox:
                title = NavigationCategory.Inbox.rawValue
                placeholderSubtitle = "Your messages"
                imageName = "inbox"
            case NavigationCategory.Profile:
                title = NavigationCategory.Profile.rawValue
                placeholderSubtitle = "Tell us about yourself"
                imageName = "favourite2"
            case NavigationCategory.News:
                title = NavigationCategory.News.rawValue
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
