//
//  UnitController.swift
//  DripDrop
//
//  Created by Jaksa Tomovic on 26/02/2018.
//  Copyright © 2018 Jaksa Tomovic. All rights reserved.
//

import UIKit

class UnitController: UIViewController {
    
    @IBOutlet weak var literButton: UIButton!
    @IBOutlet weak var ouncesButton: UIButton!
    
    let userDefaults = UserDefaults.groupUserDefaults()
    
    
    // (Male, female)
    var highlighted: (Bool, Bool) = (false, false)
    
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapMale(_ sender: Any) {
        if highlighted.0 {
            highlighted.0 = false
        } else {
            highlighted.0 = true
            highlighted.1 = false
        }
        refreshSex()
    }
    
    @IBAction func tapFemale(_ sender: Any) {
        if highlighted.1 {
            highlighted.1 = false
        } else {
            highlighted.1 = true
            highlighted.0 = false
        }
        refreshSex()
    }
    
    func refreshSex() {
        maleOnOff(bool: highlighted.0)
        femaleOnOff(bool: highlighted.1)
    }
    
    func maleOnOff(bool: Bool) {
        if bool {
            literButton.backgroundColor = Palette.palette_lightBlue
            literButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        } else {
            literButton.backgroundColor = UIColor.white
            literButton.setTitleColor(Palette.palette_lightBlue, for: UIControlState.normal)
        }
    }
    
    
    func femaleOnOff(bool: Bool) {
        if bool {
            ouncesButton.backgroundColor = Palette.palette_lightBlue
            ouncesButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        } else {
            ouncesButton.backgroundColor = UIColor.white
            ouncesButton.setTitleColor(Palette.palette_lightBlue, for: UIControlState.normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Buttons
        literButton.layer.cornerRadius = 44
        literButton.layer.borderWidth = 2
        literButton.layer.borderColor = UIColor.white.cgColor
        ouncesButton.layer.cornerRadius = 44
        ouncesButton.layer.borderWidth = 2
        ouncesButton.layer.borderColor = UIColor.white.cgColor
        
        refreshSex()
        
    }
    
    func updateUI() {
        let unit = Constants.UnitsOfMeasure(rawValue: self.userDefaults.integer(forKey: Constants.General.unitOfMeasure.key()))
        
        if (unit == Constants.UnitsOfMeasure.liters) {
            Settings.registerDefaultsForLiter()
        } else {
            Settings.registerDefaultsForOunces()
        }
    }
    
    func ouncesButtonAction() {
        self.userDefaults.set(Constants.UnitsOfMeasure.ounces.rawValue, forKey: Constants.General.unitOfMeasure.key())
        self.userDefaults.synchronize()
        updateUI()
    }
    
    func litersButtonAction() {
        self.userDefaults.set(Constants.UnitsOfMeasure.liters.rawValue, forKey: Constants.General.unitOfMeasure.key())
        self.userDefaults.synchronize()
        updateUI()
    }
    
    @IBAction func advanceUnit(_ sender: Any) {
        let alert = UIAlertController(title: "Nothing selected!", message: "Please select your prefered type of unit", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
        }
        
        alert.addAction(OKAction)
        
        func sexAlert() {
            self.present(alert, animated: true)
        }
        
        if highlighted != (false,false) {
            if highlighted.0 {
//                                defaults.set("Male", forKey: "selectedSex")
                litersButtonAction()
            } else {
                //                defaults.set("Female", forKey: "selectedSex")
                ouncesButtonAction()
            }
        } else {
            sexAlert()
        }
        // print("Sex set to \(defaults.string(forKey: "selectedSex"))")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

