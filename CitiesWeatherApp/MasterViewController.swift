//
//  MasterViewController.swift
//  CitiesWeatherApp
//
//  Created by Vlad on 3/22/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

protocol CitySelectionDelegate: class {
    func citySelected(_ newCity: City)
}

class MasterViewController: UITableViewController {

    var cities: [City]!
    @IBOutlet var citiesTableView: UITableView!
    weak var delegate: CitySelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImages()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cityTableViewCell", for: indexPath) as? CityTableViewCell
            else { fatalError("The dequeued cell is not an instance of CityTableViewCell.") }
        let city = cities[indexPath.row]
        cell.cityName.text = city.name
        cell.cityImage.image = city.image
        cell.cityDescription.text = city.description
        cell.cityWeather.text = formattedWeather()
        cell.cityCoordinates.text = formattedCoordinates(latitude: city.latitude, longtitude: city.longtitude)
        // Configure the cell...

        return cell
    }
 
    func imageFromUrl(source: String, index: Int) {
        var image: UIImage?
        Alamofire.request(source).responseData { (response) in
            if response.error == nil {
                print(response.result)
                
                if let data = response.data {
                    image = UIImage(data: data)
                    self.cities[index].image = image!
                    let indexPath = IndexPath(item: index, section: 0)
                    self.citiesTableView.reloadRows(at: [indexPath], with: .top)
                    self.delegate?.citySelected(self.cities[index])
                }
            }
        }
    }
    
    func loadImages(){
        var i: Int = 0
        while i < cities.count {
            imageFromUrl(source: cities[i].imageUrl, index: i)

            i += 1
        }
        citiesTableView.reloadData()
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
            let latitude = jsonCity["latitude"].floatValue
            let longtitude = jsonCity["longtitude"].floatValue
            let id = jsonCity["weatherInfo"]["id"].intValue
            let description = jsonCity["description"].stringValue
            let weatherInfo = WeatherInfo(id: id, description: nil, updatedAt: nil)
            let city = City(name: name, latitude: latitude, longtitude: longtitude, weatherInfo: weatherInfo, imageUrl: imageUrl, image: UIImage(named: "default_city_icon")!, description: description)
            result.append(city)
        }
        return result
    }

    
    func formattedCoordinates(latitude: Float, longtitude: Float) -> String {
        return "Latitude: \(NSString(format: "%.6f", latitude)), longtitude: \(NSString(format: "%.6f", longtitude))"
    }
    
    func formattedWeather() -> String {
        return ""
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        delegate?.citySelected(selectedCity)
        if let detailViewController = delegate as? CityDetailsViewController,
            let detailNavigationController = detailViewController.navigationController {
            splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
