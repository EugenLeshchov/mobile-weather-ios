//
//  City.swift
//  WeatherApp
//
//  Created by Vladislav Ermolovich on 3/8/18.
//  Copyright © 2018 Vladislav Ermolovich. All rights reserved.
//

import UIKit

struct City {
    let name: String
    let latitude: Double
    let longtitude: Double
    var weatherInfo: WeatherInfo
    let imageUrl: String
    var image: UIImage = UIImage(named: "default_city_icon")!
    let description: String
}
