//
//  CityAnnotation.swift
//  CitiesWeatherApp
//
//  Created by Vlad on 3/27/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import MapKit

class CityAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var windDirection: Double!
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, windDirection: Double?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        if windDirection == nil {
            self.windDirection = 0
        }
        else {
            self.windDirection = windDirection
        }
    }
}
