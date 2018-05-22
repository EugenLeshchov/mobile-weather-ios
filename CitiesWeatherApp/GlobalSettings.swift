//
//  GlobalSettings.swift
//  CitiesWeatherApp
//
//  Created by Vlad on 4/12/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

class Event<T>{
    typealias EventHandler = (T) -> ()
    private var eventHandlers = [EventHandler]()
    
    func raise(data: T){
        for handler in eventHandlers {
            handler(data)
        }
    }
    
    func addEventHandler(handler: @escaping (T)->()){
        eventHandlers.append(handler)
    }
}


class GlobalSettings  {
    static var instance = GlobalSettings()
    
    private init(){
    }
    
    let localeChangedEvent = Event<String>()
    let fontSizeChangedEvent = Event<CGFloat>()
    let fontColorChangedEvent = Event<UIColor>()
    
    var locale = "en" {
        didSet{
            localeChangedEvent.raise(data: locale)
        }
    }
    var fontSize = CGFloat(17) {
        didSet {
            fontSizeChangedEvent.raise(data: fontSize)
        }
    }
    var fontColor = UIColor.black {
        didSet {
            fontColorChangedEvent.raise(data: fontColor)
        }
    }
    
//    public static func getInstance() -> GlobalSettings {
//        return instance
//    }
}
