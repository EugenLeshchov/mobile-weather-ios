//
//  MapViewController.swift
//  CitiesWeatherApp
//
//  Created by Vlad on 3/27/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var gestureRecognizer: UITapGestureRecognizer!
    var cityAnnotation: CityAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        gestureRecognizer.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "city"
        
        if let cityAnnotation = annotation as? CityAnnotation {
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                annotationView.annotation = annotation
                return annotationView
            } else {
                let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
                annotationView.isEnabled = true
                annotationView.canShowCallout = true
                
                let calloutView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                annotationView.rightCalloutAccessoryView = calloutView
                let imageView = UIImageView()
                imageView.image = UIImage(named: "arrow_icon")
                calloutView.addSubview(imageView)
                imageView.frame = calloutView.bounds
                imageView.transform = CGAffineTransform(rotationAngle: CGFloat(cityAnnotation.windDirection).toRadians)
                return annotationView
            }
        }
        return nil
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is MKAnnotationView {
            return false
        }
        return true
    }
    	
    @IBAction func mapViewTapped(_ sender: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let cityCoordinate = mapView.convert(location,toCoordinateFrom: mapView)
        if cityAnnotation != nil {
            mapView.removeAnnotation(cityAnnotation!)
        }
        fetchWeatherForCoordinates(cityCoordinate: cityCoordinate)
    }
    
    func fetchWeatherForCoordinates(cityCoordinate: CLLocationCoordinate2D) {
        let token = "138ed6a22079c3e4f0cf209f46cfb39a"
        let lat = cityCoordinate.latitude
        let lon = cityCoordinate.longitude
        let weatherApiUrl = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(token)&units=metric"
        Alamofire.request(weatherApiUrl).responseJSON { response in
            if let data = response.data {
                let json = JSON(data)
                let windSpeed = json["wind"]["speed"].doubleValue
                let windDirection = json["wind"]["deg"].doubleValue
                let temperature = json["main"]["temp"].doubleValue
                let humidity = json["main"]["humidity"].doubleValue
                let pressure = json["main"]["pressure"].doubleValue
                let cityName = json["name"].stringValue
                let weather = self.formattedWeather(temperature: temperature, humidity: humidity, pressure: pressure)
                self.cityAnnotation = CityAnnotation(title: cityName, subtitle: weather, coordinate: cityCoordinate, windDirection: windDirection)
                self.mapView.addAnnotation(self.cityAnnotation!)

            }
        }
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
