//
//  GulpController.swift
//  DripDrop
//
//  Created by Jaksa Tomovic on 26/02/2018.
//  Copyright © 2018 Jaksa Tomovic. All rights reserved.
//

import UIKit
import pop

class GulpController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var smallGulpText: UITextField!
    @IBOutlet weak var bigGulpText: UITextField!
    @IBOutlet weak var smallSuffixLabel: UILabel!
    @IBOutlet weak var bigSuffixLabel: UILabel!
    @IBOutlet weak var smallBackgroundView: UIView!
    @IBOutlet weak var bigBackgroundView: UIView!
    @IBOutlet weak var separatorView: UIView!
    
    let userDefaults = UserDefaults.groupUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.smallGulpText.inputAccessoryView = Globals.numericToolbar(self, selector: #selector(GulpController.dismissAndSave))
        self.bigGulpText.inputAccessoryView = Globals.numericToolbar(self, selector: #selector(GulpController.dismissAndSave))
        
        self.smallBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self.smallGulpText, action: #selector(UIResponder.becomeFirstResponder)))
        self.bigBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self.bigGulpText, action: #selector(UIResponder.becomeFirstResponder)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(GulpController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GulpController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        updateUI()
    }
    
    @objc func dismissAndSave() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        _ = [self.smallGulpText, self.bigGulpText].map({$0.resignFirstResponder()})
        
        var small = 0.0
        var big = 0.0
        if let number = numberFormatter.number(from: self.smallGulpText.text ?? "0") {
            small = number.doubleValue
        }
        
        if let number = numberFormatter.number(from: self.bigGulpText.text ?? "0") {
            big = number.doubleValue
        }
        
        self.userDefaults.set(small, forKey: Constants.Gulp.small.key())
        self.userDefaults.set(big, forKey: Constants.Gulp.big.key())
        self.userDefaults.synchronize()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        dismissAndSave()
        
        return true
    }
    
     func updateUI() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        self.smallGulpText.text = numberFormatter.string(for: self.userDefaults.double(forKey: Constants.Gulp.small.key()))
        self.bigGulpText.text = numberFormatter.string(for: self.userDefaults.double(forKey: Constants.Gulp.big.key()))
        let unit = Constants.UnitsOfMeasure(rawValue: self.userDefaults.integer(forKey: Constants.General.unitOfMeasure.key()))
        
        if let unit = unit {
            self.smallSuffixLabel.text = unit.suffixForUnitOfMeasure()
            self.bigSuffixLabel.text = unit.suffixForUnitOfMeasure()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = [self.smallGulpText, self.bigGulpText].map({$0.resignFirstResponder()})
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        scrollViewTo(-(self.separatorView.frame.origin.y + self.separatorView.frame.size.height), from: 0)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        scrollViewTo(0, from: -(self.separatorView.frame.origin.y + self.separatorView.frame.size.height))
    }
    
    func scrollViewTo(_ offset: CGFloat, from: CGFloat) {
        let move = POPBasicAnimation(propertyNamed: kPOPLayerTranslationY)
        move?.fromValue = from
        move?.toValue = offset
        move?.removedOnCompletion = true
        self.view.layer.pop_add(move, forKey: "move")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return Globals.numericTextField(textField, shouldChangeCharactersInRange: range, replacementString: string)
    }
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


