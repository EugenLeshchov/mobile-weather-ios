//
//  ContainerViewController.swift
//  CitiesWeatherApp
//
//  Created by Vlad on 3/25/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import SwiftyJSON

class ContainerViewController: UIViewController, UISplitViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        guard let splitViewController = self.childViewControllers.first as? UISplitViewController,
            let leftNavController = splitViewController.viewControllers.first as? UINavigationController,
            let masterViewController = leftNavController.topViewController as? MasterViewController,
            let rightNavController = splitViewController.viewControllers.last as? UINavigationController,
            let detailViewController = rightNavController.topViewController as? CityDetailsViewController
            else { fatalError() }
        masterViewController.cities = loadCities()
        let firstCity = masterViewController.cities.first
        detailViewController.city = firstCity
        masterViewController.delegate = detailViewController
        detailViewController.navigationItem.leftItemsSupplementBackButton = true
        detailViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self
        splitViewController.preferredDisplayMode = .allVisible
    }
    
    override func viewDidAppear(_ animated: Bool) {
        performOverrideTraitCollection()
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        performOverrideTraitCollection()
    }
    
    private func performOverrideTraitCollection() {
        if UIDevice.current.orientation.isLandscape {
            print("landscape")
            for childVC in self.childViewControllers {
                setOverrideTraitCollection(UITraitCollection(horizontalSizeClass:  .regular), forChildViewController: childVC)
            }
        }        
        if UIDevice.current.orientation.isPortrait {
            print("portrait")
            for childVC in self.childViewControllers {
                setOverrideTraitCollection(UITraitCollection(horizontalSizeClass:  .compact), forChildViewController: childVC)
            }
        }	
    }
    
    func loadCities() ->  [City] {
        let fileName = "cities"
        let fileType = "json"
        let path = Bundle.main.path(forResource: fileName, ofType: fileType)
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            let json = JSON(data)
            return parseCities(json: json)
        }
        catch {
            print("An error occuried while parsing "+fileName+"."+fileType)
        }
        
        return []
    }
    
    func parseCities(json: JSON) -> [City]{
        var result: [City] = []
        for jsonCity in json.arrayValue {
            let name = jsonCity["name"].stringValue
            let imageUrl = jsonCity["imageUrl"].stringValue
            let latitude = jsonCity["latitude"].doubleValue
            let longtitude = jsonCity["longtitude"].doubleValue
            let id = jsonCity["weatherInfo"]["id"].intValue
            let description = jsonCity["description"].stringValue
            let weatherInfo = WeatherInfo(id: id, windSpeed: nil, windDirection: nil, temperature: nil, humidity: nil, pressure: nil)
            let city = City(name: name, latitude: latitude, longtitude: longtitude, weatherInfo: weatherInfo, imageUrl: imageUrl, image: UIImage(named: "default_city_icon")!, description: description)
            result.append(city)
        }
        return result
    }
}
