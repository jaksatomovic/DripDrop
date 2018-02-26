//
//  AgeController.swift
//  DripDrop
//
//  Created by Jaksa Tomovic on 26/02/2018.
//  Copyright © 2018 Jaksa Tomovic. All rights reserved.
//

import UIKit

let dateFormatter = DateFormatter()

class AgeController: UIViewController {
    
    let userDefaults = UserDefaults.groupUserDefaults()

    
    @IBOutlet weak var datepicker: UIDatePicker!
    var datepickerChanged: Bool = false
    
    @IBAction func datepickerAction(_ sender: Any) {
        datepickerChanged = true
    }
    
    func updateBirthday() {
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = userDefaults.string(forKey: Constants.Birthday.birthday.key()) else {return}
        datepicker.setDate(dateFormatter.date(from: date)!, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load datepicker: font, colour
        datepicker.setValue(UIColor.black, forKeyPath: "textColor")
        
        datepicker.maximumDate = NSDate() as Date
        updateBirthday()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backSex(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func advanceWake(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "Please enter a valid birthday!", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
        }
        
        alert.addAction(OKAction)
        
        func ageAlert() {
            self.present(alert, animated: true)
        }
        
        if datepickerChanged {
            dateFormatter.calendar = Calendar(identifier: .iso8601)
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            let birthdayString = dateFormatter.string(from: datepicker.date)
            userDefaults.set(birthdayString, forKey: Constants.Birthday.birthday.key())
            refreshGoals()
        } else {
            ageAlert()
        }
        
    }

    
    
    func refreshGoals() {
        
        var goal : Double = 0.0
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let calendar : NSCalendar = NSCalendar.current as NSCalendar
        
        let birthday = dateFormatter.date(from: userDefaults.string(forKey: Constants.Birthday.birthday.key())!)
        let now = NSDate()
        
        let ageComponents = calendar.components(.year, from: birthday!, to: now as Date, options: [])
        let age: Int = ageComponents.year!
        
        if userDefaults.string(forKey: Constants.Sex.sex.key()) == "Male" {
            
            switch age {
            case 0..<3:
                goal = 1.3
            case 3..<8:
                goal = 1.7
            case 8..<13:
                goal = 2.4
            case 13..<18:
                goal = 3.3
            case 18..<150:
                goal = 3.7
            default:
                goal = 3.7
            }
            
        } else /* female */ {
            
            switch age {
            case 0..<3:
                goal = 1.3
            case 3..<8:
                goal = 1.7
            case 8..<13:
                goal = 2.1
            case 13..<18:
                goal = 2.3
            case 18..<150:
                goal = 2.7
            default:
                goal = 2.7
            }
            
        }
  
        self.userDefaults.set(goal, forKey: Constants.Gulp.goal.key())
        print(userDefaults.double(forKey: Constants.Gulp.goal.key()))
        self.userDefaults.synchronize()
        
    }
    
    
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
