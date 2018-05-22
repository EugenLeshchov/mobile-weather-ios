//
//  TabBarViewController.swift
//  CitiesWeatherApp
//
//  Created by Vlad on 4/12/18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    @IBOutlet weak var tabBarControl: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupview()
        // Do any additional setup after loading the view.
    }
    
    func setupview() {
        tabBarControl.items![0].accessibilityIdentifier = "main"
        tabBarControl.items![1].accessibilityIdentifier = "map"
        tabBarControl.items![2].accessibilityIdentifier = "settings"
        GlobalSettings.instance.localeChangedEvent.addEventHandler { (locale) in
            self.updateLocale(locale: locale)
        }
    }
    
    func updateLocale(locale: String){
        print("new locale "+locale)
        for item in tabBarControl.items! {
            item.title = localizedString(key: item.accessibilityIdentifier!, lang: locale)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
