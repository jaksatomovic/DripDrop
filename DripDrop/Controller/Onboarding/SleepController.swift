//
//  SleepController.swift
//  DripDrop
//
//  Created by Jaksa Tomovic on 26/02/2018.
//  Copyright © 2018 Jaksa Tomovic. All rights reserved.
//

import UIKit

class SleepController: UIViewController {
    
    let userDefaults = UserDefaults.groupUserDefaults()

    
    //FIXME: Update outlets
    @IBOutlet weak var datepicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datepicker.locale = Locale(identifier: "en_US")
        datepicker.setValue(UIColor.black, forKeyPath: "textColor")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backWakeTime(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //FIXME: Create IBAction and confirm working
    
    @IBAction func advanceUsage(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.dateFormat = "HH"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let wakeString = userDefaults.string(forKey: Constants.Notification.from.key())
        let wakeTime = dateFormatter.date(from: wakeString!)
        if datepicker.date.timeIntervalSince(wakeTime! as Date) > 0 {
            // Sleep time is larger than wake time
            self.userDefaults.set(dateFormatter.string(from: datepicker.date), forKey: Constants.Notification.to.key())
            self.userDefaults.synchronize()
        } else {
            // Wake time is larger than sleep time
            
            let alert = UIAlertController(title: "Choose a valid time", message: "Choose a sleep time later than the wake time.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
            }
            
            alert.addAction(OKAction)
            self.present(alert, animated: true) {
            }
        }
        
    }
}
