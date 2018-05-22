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
    private let citiesRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citiesTableView.refreshControl = citiesRefreshControl
        citiesRefreshControl.addTarget(self, action: #selector(MasterViewController.updateCities), for: .valueChanged)
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
        let weatherInfo = city.weatherInfo
        cell.cityName.text = city.name
        cell.cityImage.image = city.image
        cell.cityDescription.text = city.description
        cell.cityWeather.text = formattedWeather(temperature: weatherInfo.temperature, humidity: weatherInfo.humidity, pressure: weatherInfo.pressure)
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
//                    self.delegate?.citySelected(self.cities[index])
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

    
    func formattedCoordinates(latitude: Double, longtitude: Double) -> String {
        return "Latitude: \(NSString(format: "%.6f", latitude)), longtitude: \(NSString(format: "%.6f", longtitude))"
    }
    
    func formattedWeather(temperature: Double?, humidity: Double?, pressure: Double?) -> String {
        var weather: String = ""
        if temperature != nil { weather += "Temperature: \(temperature!)°C"}
        if humidity != nil { weather += " humidity: \(humidity!)%"}
        if pressure != nil { weather += " pressure: \(pressure!) mm Hg"}
        return weather
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        delegate?.citySelected(selectedCity)
        if let detailViewController = delegate as? CityDetailsViewController,
            let detailNavigationController = detailViewController.navigationController {
            splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
        }
    }
    
    func updateCityWeatherInfo(index: Int){
        let token = "138ed6a22079c3e4f0cf209f46cfb39a"
        let weatherApiUrl = "https://api.openweathermap.org/data/2.5/weather?id=\(cities[index].weatherInfo.id)&appid=\(token)&units=metric"
        Alamofire.request(weatherApiUrl).responseJSON { response in
            print(response)
            if let data = response.data {
                let json = JSON(data)
                print(json)
                self.cities[index].weatherInfo.windSpeed = json["wind"]["speed"].doubleValue
                self.cities[index].weatherInfo.windDirection = json["wind"]["deg"].doubleValue
                self.cities[index].weatherInfo.temperature = json["main"]["temp"].doubleValue
                self.cities[index].weatherInfo.humidity = json["main"]["humidity"].doubleValue
                self.cities[index].weatherInfo.pressure = json["main"]["pressure"].doubleValue
                let indexPath = IndexPath(item: index, section: 0)
                self.citiesTableView.reloadRows(at: [indexPath], with: .top)
            }
        }
    }
    
    func updateCitiesWeatherInfo() {
        for i in 0..<cities.count {
            updateCityWeatherInfo(index: i)
        }
    }
    
    @objc func updateCities() {
        print("Cities updated")
        updateCitiesWeatherInfo()
        citiesRefreshControl.endRefreshing()
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
