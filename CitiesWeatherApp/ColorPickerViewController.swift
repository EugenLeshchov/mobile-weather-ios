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
    @IBOutlet weak var redLabel: CustomizableLabel!
    @IBOutlet weak var blueLabel: CustomizableLabel!
    var colorChangedCallback: ((_ color: UIColor)->())!
    @IBOutlet weak var greenLabel: CustomizableLabel!
    
    var color: Color!
    var previousColor: UIColor!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView(){
        if previousColor.cgColor.components!.count > 3 {
            redSlider.value = (Float)(previousColor.cgColor.components![0]*255)
            greenSlider.value = (Float)(previousColor.cgColor.components![1]*255)
            blueSlider.value = (Float)(previousColor.cgColor.components![2]*255)
        }
        color = Color(red: redSlider.value, green: greenSlider.value, blue: blueSlider.value)
        colorView.backgroundColor = previousColor
        GlobalSettings.instance.localeChangedEvent.addEventHandler { (locale) in
            self.updateLocale(locale: locale)
        }
        GlobalSettings.instance.fontSizeChangedEvent.addEventHandler { (fontSize) in
            self.updateFontSize(fontSize: fontSize)
        }
        GlobalSettings.instance.fontColorChangedEvent.addEventHandler { (fontColor) in
            self.updateFontColor(fontColor: fontColor)
        }
        applyGlobalSettings()
    }
    
    func applyGlobalSettings(){
        updateLocale(locale: GlobalSettings.instance.locale)
        updateFontSize(fontSize: GlobalSettings.instance.fontSize)
        updateFontColor(fontColor: GlobalSettings.instance.fontColor)
    }
    
    func updateFontSize(fontSize: CGFloat){
        for label in [redLabel, greenLabel, blueLabel] {
            label!.font = UIFont(name: label!.font.fontName, size: fontSize)
        }
    }
    
    func updateFontColor(fontColor: UIColor){
        for label in [redLabel, greenLabel, blueLabel] {
            label!.textColor = fontColor
        }
    }
    
    func updateLocale(locale: String){
        for label in [redLabel, greenLabel, blueLabel] {
            label!.text = localizedString(key: label!.accessibilityIdentifier!, lang: locale)
        }
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
        GlobalSettings.instance.fontColor = selectedColor
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

