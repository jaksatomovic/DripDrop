//
//  WakeController.swift
//  DripDrop
//
//  Created by Jaksa Tomovic on 26/02/2018.
//  Copyright © 2018 Jaksa Tomovic. All rights reserved.
//

import UIKit

class WakeController: UIViewController {
    
    let userDefaults = UserDefaults.groupUserDefaults()

    
    @IBOutlet weak var datepicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datepicker.locale = Locale(identifier: "en_US")
        datepicker.setValue(UIColor.black, forKeyPath: "textColor")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backAge(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func advanceSleep(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.dateFormat = "HH"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        self.userDefaults.set(dateFormatter.string(from: datepicker.date), forKey: Constants.Notification.from.key())
        self.userDefaults.synchronize()
        print(dateFormatter.string(from: datepicker.date))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
