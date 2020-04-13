//
//  ProfilePlaybook.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 5/31/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import Foundation


struct ProvidedServicesProfile {
    var supportedMobility: [Limitation] = []
    var supportedDevelopmentalAge: [DevelopmentalStage] = []
    var actualAge: Int = -1
    var diagnosis: [DevelopmentalDiagnosis] = []
    
    func isMatch(for: FilterDictionary) -> Bool {
        
        return true
    }
}

enum ISOCountryCode : String {      // only support USA initially
    case usa = "USA", gbr = "GBR"
}

struct LocationProfile {
    var coordinates: CLLocationCoordinate2D!
    var countryCode: ISOCountryCode
    var regionName: String
    var cityName: String
    var zipCode: String
    
    init(zip:String)
    {
        countryCode = ISOCountryCode.usa
        cityName = ""
        regionName = ""
        zipCode = zip
        coordinates = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }

    init(latitude:Double, longitude:Double, city:String, state:String, zip:String, country:ISOCountryCode = .usa)
    {
        countryCode = country
        cityName = city
        regionName = state
        zipCode = zip
        coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}


