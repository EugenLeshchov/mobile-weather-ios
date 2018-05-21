//
//  LocalizationManager.swift
//  CitiesWeatherApp
//
//  Created by Vlad on 4/4/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation

class LocalizationManager {
    private var localizationQueue: [(_ locale: String)->()]!
    
    init() {
        localizationQueue = []
        NotificationCenter.default.addObserver(self, selector: #selector(performLocalization(notification:)), name: NSNotification.Name(rawValue: "localizeStoryboard"), object: nil)
    }
    
    func addLocalizationCallback(callback: @escaping (_ locale: String)->()){
        localizationQueue?.append(callback)
    }
    
    @objc func performLocalization(notification: NSNotification){
        for callback in localizationQueue {
            let locale = notification.object as! String
            callback(locale)
        }
    }
}
