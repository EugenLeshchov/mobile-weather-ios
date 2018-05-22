//
//  ColorPickerViewController.swift
//  CitiesWeatherApp
//
//  Created by Vlad on 4/3/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var colorView: UIView!
    var colorChangedCallback: ((_ color: UIColor)->())!
    
    var color: Color!
    var previousColor: UIColor!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(previousColor.cgColor.components)
        if previousColor.cgColor.components!.count > 3 {
            redSlider.value = (Float)(previousColor.cgColor.components![0]*255)
            greenSlider.value = (Float)(previousColor.cgColor.components![1]*255)
            blueSlider.value = (Float)(previousColor.cgColor.components![2]*255)
        }
        color = Color(red: redSlider.value, green: greenSlider.value, blue: blueSlider.value)
        colorView.backgroundColor = previousColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func colorSliderChanged(_ sender: UISlider) {
        switch sender.tag{
        case 0: color.setRed(red: sender.value)
        case 1: color.setGreen(green: sender.value)
        case 2: color.setBlue(blue: sender.value)
        default: print("Could not choose color")
        }
        let selectedColor = color.getColor()
        colorChangedCallback(selectedColor)
        colorView.backgroundColor = selectedColor
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

