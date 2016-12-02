//
//  NavigationContent.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 12/1/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit

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
        
        navigationArray.append(DestinationDescriptor(dest: Destination.Organizations))
        navigationArray.append(DestinationDescriptor(dest: Destination.Events))
        navigationArray.append(DestinationDescriptor(dest: Destination.Facilities))
        navigationArray.append(DestinationDescriptor(dest: Destination.Travel))
        navigationArray.append(DestinationDescriptor(dest: Destination.News))
        navigationArray.append(DestinationDescriptor(dest: Destination.Inbox))
        navigationArray.append(DestinationDescriptor(dest: Destination.Profile))
    }
    
    func updateSubtitles() {
        var index = 0
        for item in navigationArray {
            switch item.destination {
            case Destination.Organizations:
                let _ = 8
                //navigationArray[index].subtitle = "Hi MOM!"
                
            case Destination.Events:
                let _ = 8
                
            case Destination.Facilities:
                let _ = 8
                
            case Destination.Travel:
                let _ = 8
                
            case Destination.News:
                let _ = 8
                
            case Destination.Inbox:
                navigationArray[index].subtitle = "You have 3 unread messages"
                
            case Destination.Profile:
                let _ = 8
            }
            
            index = index + 1
        }
    }

//    func update1Subtitle(dest: DestinationDescriptor) {
//        switch dest.destination {
//        case Destination.Organizations:
//            let _ = 8
//            //navigationArray[index].subtitle = "Hi MOM!"
//            
//        case Destination.Events:
//            let _ = 8
//            
//        case Destination.Facilities:
//            let _ = 8
//            
//        case Destination.Travel:
//            let _ = 8
//            
//        case Destination.News:
//            let _ = 8
//            
//        case Destination.Inbox:
//            dest.subtitle = "You have 3 unread messages"
//            
//        case Destination.Profile:
//            let _ = 8
//        }
//    }
}
