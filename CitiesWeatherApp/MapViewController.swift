//
//  MapViewController.swift
//  CitiesWeatherApp
//
//  Created by Vlad on 3/27/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var gestureRecognizer: UITapGestureRecognizer!
    var cityAnnotation: CityAnnotation?
    var cityCoordinate: CLLocationCoordinate2D?
    
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
                
                let windIcon = UIImage(named: "arrow_icon")
                let windIconView = UIImageView()
                windIconView.image = windIcon
                windIconView.clipsToBounds = true
                let transform = CGAffineTransform(scaleX: 0.3, y: 0.3).concatenating(CGAffineTransform(rotationAngle: CGFloat(275).toRadians))
                windIconView.transform = transform
                annotationView.detailCalloutAccessoryView = windIconView
                return annotationView
            }
        }
        return nil
    }
    	
    @IBAction func mapViewTapped(_ sender: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        cityCoordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        if cityAnnotation != nil {
            mapView.removeAnnotation(cityAnnotation!)
            
        }
        cityAnnotation = CityAnnotation(title: "city", subtitle: "weather", coordinate: cityCoordinate!, windDirection: 45)
        mapView.addAnnotation(cityAnnotation!)
     

        
        
//        mapView.selectAnnotation(cityAnnotation!, animated: false)
        
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
