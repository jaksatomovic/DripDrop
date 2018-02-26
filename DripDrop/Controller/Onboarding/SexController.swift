//
//  SexController.swift
//  DripDrop
//
//  Created by Jaksa Tomovic on 26/02/2018.
//  Copyright © 2018 Jaksa Tomovic. All rights reserved.
//

import UIKit

class SexController: UIViewController {
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    
    let userDefaults = UserDefaults.groupUserDefaults()

    
    // (Male, female)
    var highlighted: (Bool, Bool) = (false, false)
    
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
            maleButton.backgroundColor = Palette.palette_lightBlue
            maleButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        } else {
            maleButton.backgroundColor = UIColor.white
            maleButton.setTitleColor(Palette.palette_lightBlue, for: UIControlState.normal)
        }
    }
    
    
    func femaleOnOff(bool: Bool) {
        if bool {
            femaleButton.backgroundColor = Palette.palette_lightBlue
            femaleButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        } else {
            femaleButton.backgroundColor = UIColor.white
            femaleButton.setTitleColor(Palette.palette_lightBlue, for: UIControlState.normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Buttons
        maleButton.layer.cornerRadius = 44
        maleButton.layer.borderWidth = 2
        maleButton.layer.borderColor = UIColor.white.cgColor
        femaleButton.layer.cornerRadius = 44
        femaleButton.layer.borderWidth = 2
        femaleButton.layer.borderColor = UIColor.white.cgColor
        
        refreshSex()
        
    }

    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func advanceAge(_ sender: Any) {
        let alert = UIAlertController(title: "Nothing selected!", message: "Please select your sex", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
        }
        
        alert.addAction(OKAction)
        
        func sexAlert() {
            self.present(alert, animated: true)
        }
        
        if highlighted != (false,false) {
            if highlighted.0 {
                userDefaults.set("Male", forKey: Constants.Sex.sex.key())
            } else {
                userDefaults.set("Female", forKey: Constants.Sex.sex.key())
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
