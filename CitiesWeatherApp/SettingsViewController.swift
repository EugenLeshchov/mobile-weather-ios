//
//  SettingsViewController.swift
//  CitiesWeatherApp
//
//  Created by Vlad on 4/3/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var fontColor: UIView!
    @IBOutlet weak var fontSizeSlider: UISlider!
    @IBOutlet weak var fontSizeLabel: UILabel!
    @IBOutlet weak var languageControl: UISegmentedControl!
    @IBOutlet weak var fontColorLabel: CustomizableLabel!
    @IBOutlet weak var languageLabel: CustomizableLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView(){
        GlobalSettings.instance.localeChangedEvent.addEventHandler { (locale) in
            self.updateLocale(locale: locale)
        }
    }
    
    func updateLocale(locale: String){
        for label in [fontColorLabel, fontSizeLabel, languageLabel] {
            label!.text = localizedString(key: label!.accessibilityIdentifier!, lang: locale)
        }
        languageControl.setTitle(localizedString(key: "english", lang: locale), forSegmentAt: 0)
        languageControl.setTitle(localizedString(key: "russian", lang: locale), forSegmentAt: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func colorPickerTapped(_ sender: Any) {
        performSegue(withIdentifier: "chooseColorSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ColorPickerViewController {
            destination.previousColor = fontColor.backgroundColor
            destination.colorChangedCallback = { (color: UIColor) -> Void in
                self.fontColor.backgroundColor = color
                NotificationCenter.default.post(name: Notification.Name("changeFontColor"), object: color)
            }
        }
    }
    
    @IBAction func fontSizeChanged(_ sender: Any) {
        let fontSize = CGFloat(fontSizeSlider.value)
        GlobalSettings.instance.fontSize = fontSize
    }
    
    @IBAction func languageChanged(_ sender: Any) {
        switch languageControl.selectedSegmentIndex {
            case 0:
                GlobalSettings.instance.locale = "en"
            case 1:
                GlobalSettings.instance.locale = "ru"
            default: break
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
