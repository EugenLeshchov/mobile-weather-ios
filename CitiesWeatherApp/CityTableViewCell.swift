//
//  CityTableViewCell.swift
//  WeatherApp
//
//  Created by Vladislav Ermolovich on 3/8/18.
//  Copyright © 2018 Vladislav Ermolovich. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityWeather: UILabel!
    @IBOutlet weak var cityCoordinates: UILabel!
    @IBOutlet weak var cityDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
