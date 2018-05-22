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
    override func viewDidLoad() {
        super.viewDidLoad()
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
        print(fontSize)
//        fontSizeLabel.font = UIFont(name: fontSizeLabel.font.fontName, size: fontSize)
//        fontSizeLabel.sizeToFit()
        
        UILabel.appearance().defaultFont = UIFont.systemFont(ofSize: fontSize)
        NotificationCenter.default.post(name: Notification.Name("changeFontSize"), object: fontSize)

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
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeFontSize(notification:)), name: NSNotification.Name(rawValue: "changeFontSize"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeFontColor(notification:)), name: NSNotification.Name(rawValue: "changeFontColor"), object: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeFontSize(notification:)), name: NSNotification.Name(rawValue: "changeFontSize"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeFontColor(notification:)), name: NSNotification.Name(rawValue: "changeFontColor"), object: nil)
    }
    
    @objc func changeFontSize(notification:NSNotification){
        
        self.font = UIFont(name: self.font.fontName, size: notification.object as! CGFloat)
    }
    
    @objc func changeFontColor(notification:NSNotification){
        self.textColor = notification.object as! UIColor
    }
    
}
