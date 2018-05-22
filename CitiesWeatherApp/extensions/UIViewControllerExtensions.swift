//
//  UIViewControllerExtensions.swift
//  CitiesWeatherApp
//
//  Created by Vlad on 4/17/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
extension UIViewController {
    func localizedString(key: String, lang: String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(key, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    func formattedCoordinates(latitude: Double, longtitude: Double) -> String {
        return "Latitude: \(NSString(format: "%.2f", latitude)), longtitude: \(NSString(format: "%.2f", longtitude))"
    }
    
    func formattedWeather(temperature: Double?, humidity: Double?, pressure: Double?) -> String {
        var weather: String = ""
        if temperature != nil { weather += "Temperature: \(temperature!)°C"}
        if humidity != nil { weather += " humidity: \(humidity!)%"}
        if pressure != nil { weather += " pressure: \(pressure!) mm Hg"}
        return weather
    }
}
