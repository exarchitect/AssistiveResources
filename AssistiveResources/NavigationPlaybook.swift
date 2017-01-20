//
//  NavigationPlaybook.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 5/12/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import Foundation



enum Destination : String {
    case Organizations, Events, Facilities, Travel, Inbox, Profile, News
}


class NavigationContent: NSObject {
    
    private var navigationArray:[DestinationDescriptor] = []
    //private var usrModelController : UserModelController? = nil
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
        
        navigationArray.append(DestinationDescriptor(dest: Destination.Organizations))
        navigationArray.append(DestinationDescriptor(dest: Destination.Events))
        navigationArray.append(DestinationDescriptor(dest: Destination.Facilities))
        navigationArray.append(DestinationDescriptor(dest: Destination.Travel))
        navigationArray.append(DestinationDescriptor(dest: Destination.News))
        navigationArray.append(DestinationDescriptor(dest: Destination.Inbox))
        navigationArray.append(DestinationDescriptor(dest: Destination.Profile))
    }
    
//    func dependencies(userModelController: UserModelController) {
//        self.usrModelController = userModelController
//    }
    
    func updateSubtitles() {
        var index = 0
        for item in navigationArray {
            switch item.destination {
            case Destination.Organizations:
                let _ = 8
                //navigationArray[index].subtitle = "Hi MOM!"
                
            case Destination.Events:
                //if self.usrModelController != nil {
                    navigationArray[index].subtitle = "Regional and national events in your area"
                //}
                
            case Destination.Facilities:
                let _ = 8
                
            case Destination.Travel:
                let _ = 8
                
            case Destination.News:
                let _ = 8
                
            case Destination.Inbox:
                //if self.usrModelController != nil {
                    navigationArray[index].subtitle = "You have 3 unread messages"
                //}
                
            case Destination.Profile:
                let _ = 8
            }
            
            index = index + 1
        }
    }
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
                placeholderSubtitle = "Find restrooms and other family-friendly facilities"
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
                placeholderSubtitle = "Tell us about yourself so we can help"
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
