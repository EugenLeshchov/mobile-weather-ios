//
//  color.swift
//  CitiesWeatherApp
//
//  Created by Vlad on 4/3/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

class Color {
    private var red: CGFloat
    private var green: CGFloat
    private var blue: CGFloat
    
    init(red: Float, green: Float, blue: Float) {
        self.red = CGFloat(red)
        self.green = CGFloat(green)
        self.blue = CGFloat(blue)
    }
    
    func setRed(red: Float){
        self.red = CGFloat(red)
    }
    
    func setGreen(green: Float){
        self.green = CGFloat(green)
    }
    
    func setBlue(blue: Float){
        self.blue = CGFloat(blue)
    }
    
    func getColor() -> UIColor {
        return UIColor(displayP3Red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
}
