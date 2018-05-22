//
//  CityDetailsViewController.swift
//  CitiesWeatherApp
//
//  Created by Vlad on 3/22/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import MapKit

class CityDetailsViewController: UIViewController {

    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityCoordinates: UILabel!
    @IBOutlet weak var cityWeather: UILabel!
    @IBOutlet weak var cityDescription: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var city: City? {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        loadViewIfNeeded()
        cityName.text = city!.name
        cityCoordinates.text = formattedCoordinates(latitude: city!.latitude, longtitude: city!.longtitude)
        cityWeather.text = formattedWeather()
        cityDescription.text = city!.description
        cityImage.image = city?.image
    }
    
    func formattedCoordinates(latitude: Float, longtitude: Float) -> String {
        return "Latitude: \(NSString(format: "%.6f", latitude)), longtitude: \(NSString(format: "%.6f", longtitude))"
    }
    
    func formattedWeather() -> String {
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CityDetailsViewController: CitySelectionDelegate {
    func citySelected(_ newCity: City) {
        city = newCity
    }
}
