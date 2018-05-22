//
//  CityDetailsViewController.swift
//  CitiesWeatherApp
//
//  Created by Vlad on 3/22/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import MapKit

class CityDetailsViewController: UIViewController, MKMapViewDelegate {

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
        let weatherInfo = city?.weatherInfo
        let weather = formattedWeather(temperature: weatherInfo!.temperature, humidity: weatherInfo!.humidity, pressure: weatherInfo!.pressure)
        cityName.text = city!.name
        cityCoordinates.text = formattedCoordinates(latitude: city!.latitude, longtitude: city!.longtitude)
        cityWeather.text = weather
        cityDescription.text = city!.description
        cityDescription.sizeToFit()
        cityImage.image = city?.image
        let coordinate = CLLocationCoordinate2DMake(city!.latitude, city!.longtitude)
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 500000, 500000)
        mapView.setRegion(region, animated: true)
        let annotation = CityAnnotation(title: city!.name, subtitle: weather, coordinate: coordinate, windDirection: weatherInfo?.windDirection)
        mapView.addAnnotation(annotation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
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

extension CGFloat {
     var toRadians: CGFloat { return self * .pi / 180 }
}
