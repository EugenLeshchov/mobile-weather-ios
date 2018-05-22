//
//  CustomizableLabel.swift
//  CitiesWeatherApp
//
//  Created by Vlad on 4/17/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
class CustomizableLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        GlobalSettings.instance.fontSizeChangedEvent.addEventHandler {(fontSize) in
            self.changeFontSize(fontSize: CGFloat(fontSize))
        }
        GlobalSettings.instance.fontColorChangedEvent.addEventHandler {(fontColor) in
            self.changeFontColor(fontColor: fontColor)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        GlobalSettings.instance.fontSizeChangedEvent.addEventHandler {(fontSize) in
            self.changeFontSize(fontSize: CGFloat(fontSize))
        }
        GlobalSettings.instance.fontColorChangedEvent.addEventHandler {(fontColor) in
            self.changeFontColor(fontColor: fontColor)
        }
    }
    
    @objc func changeFontSize(fontSize: CGFloat){
        
        self.font = UIFont(name: self.font.fontName, size: fontSize)
    }
    
    @objc func changeFontColor(fontColor: UIColor){
        self.textColor = fontColor
    }
    
    func localizedString(key: String, lang: String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(key, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
