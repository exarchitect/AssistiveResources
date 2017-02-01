//
//  PropertySettings.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 5/25/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import UIKit


enum UserPropertyKeys {
    //static let Primary_Key  = "needs.settings"
    static let User_Name = "needs.email"
    static let User_Password = "needs.password"
    static let Remember_Me = "needs.rememberme"
    static let Location_Zipcode = "needs.zipcode"
}


final class PropertySettings: NSObject {

    var rememberMe: Bool
    var username: String!
    var password: String!
    var zipcode: String!
    
    static let sharedInstance = PropertySettings()     // singleton
    
    private override init() {
        username = ""
        password = ""
        rememberMe = true
        zipcode = "00000"
        
        super.init()
    }
    
    func read () {
        let usrDefaults = UserDefaults.standard
        if let usrnm = usrDefaults.string(forKey: UserPropertyKeys.User_Name) {
            username = usrnm
        }
        if let pswd = usrDefaults.string(forKey: UserPropertyKeys.User_Password) {
            password = pswd
        }
        rememberMe =  (usrDefaults.bool(forKey: UserPropertyKeys.Remember_Me))
        if let zip = usrDefaults.string(forKey: UserPropertyKeys.Location_Zipcode) {
            password = zip
        }
    }
    
    func write () {
        let usrDefaults = UserDefaults.standard
        usrDefaults.set(username, forKey: UserPropertyKeys.User_Name)
        usrDefaults.set(password, forKey: UserPropertyKeys.User_Password)
        usrDefaults.set(rememberMe, forKey: UserPropertyKeys.Remember_Me)
        usrDefaults.set(zipcode, forKey: UserPropertyKeys.Location_Zipcode)
        
        usrDefaults.synchronize()
    }
    
    func clear () {
        // tbd
        
        //usrDefaults.synchronize()
    }
    
}


