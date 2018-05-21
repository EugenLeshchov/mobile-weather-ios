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
    var localizationManager: LocalizationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageControl.setTitle("English", forSegmentAt: 0)
        languageControl.setTitle("Russian", forSegmentAt: 1)
        localizationManager = LocalizationManager()
        localizationManager.addLocalizationCallback() { (locale: String) in
            self.tabBarItem.title = self.tabBarItem.title!.localized(lang: locale)
        }
        localizationManager.addLocalizationCallback() { (locale: String) in
            let localizedTitle = self.languageControl.titleForSegment(at: 0)?.localized(lang: locale)
            self.languageControl.setTitle(localizedTitle, forSegmentAt: 0)
        }
        localizationManager.addLocalizationCallback() { (locale: String) in
            let localizedTitle = self.languageControl.titleForSegment(at: 1)?.localized(lang: locale)
            self.languageControl.setTitle(localizedTitle, forSegmentAt: 1)
        }
        // Do any additional setup after loading the view.
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
        NotificationCenter.default.post(name: Notification.Name("changeFontSize"), object: fontSize)

    }
    
    @IBAction func languageChanged(_ sender: Any) {
        switch languageControl.selectedSegmentIndex {
            case 0:
                NotificationCenter.default.post(name: Notification.Name("localizeStoryboard"), object: "en")
                NotificationCenter.default.post(name: Notification.Name("changeLocale"), object: "en")
            case 1:
                NotificationCenter.default.post(name: Notification.Name("localizeStoryboard"), object: "ru")
                NotificationCenter.default.post(name: Notification.Name("changeLocale"), object: "ru")

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

extension UILabel{
    var defaultFont: UIFont? {
        get { return self.font }
        set { self.font = newValue }
    }
    }

class CustomizableLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeFontSize(notification:)), name: NSNotification.Name(rawValue: "changeFontSize"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeFontColor(notification:)), name: NSNotification.Name(rawValue: "changeFontColor"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLocale(notification:)), name: NSNotification.Name(rawValue: "changeLocale"), object: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeFontSize(notification:)), name: NSNotification.Name(rawValue: "changeFontSize"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeFontColor(notification:)), name: NSNotification.Name(rawValue: "changeFontColor"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLocale(notification:)), name: NSNotification.Name(rawValue: "changeLocale"), object: nil)
    }
    
    @objc func changeFontSize(notification:NSNotification){
        
        self.font = UIFont(name: self.font.fontName, size: notification.object as! CGFloat)
    }
    
    @objc func changeFontColor(notification:NSNotification){
        self.textColor = notification.object as! UIColor
    }
    
    @objc func changeLocale(notification:NSNotification){
        self.text = self.text?.localized(lang: notification.object as! String)
    }
}

extension String {
    func localized(lang: String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

