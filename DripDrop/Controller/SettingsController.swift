//
//  SettingsController.swift
//  DripDrop
//
//  Created by Jaksa Tomovic on 22/02/2018.
//  Copyright © 2018 Jaksa Tomovic. All rights reserved.
//

import UIKit
import AHKActionSheet
//import WatchConnectivity

class SettingsController: UIViewController {
    
    let cellID = "cellID"
    
    let userDefaults = UserDefaults.groupUserDefaults()
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    
    var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.allowsSelection = true
        return tv
    }()
    
    var unitOfMesureLabel: UILabel = {
        let label = UILabel()
        label.text = "Label"
        label.textAlignment = .right
        label.textColor = .lightGray
        return label
    }()
    var smallPortionText: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .right
        tf.textColor = .lightGray
        return tf
    }()
    var largePortionText: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .right
        tf.textColor = .lightGray
        return tf
    }()
    var dailyGoalText: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .right
        tf.textColor = .lightGray
        return tf
    }()
    var notificationSwitch: UISwitch = {
        let uis = UISwitch()
        return uis
    }()
    var healthSwitch: UISwitch = {
        let uis = UISwitch()
        return uis
    }()
    var notificationFromLabel: UILabel = {
        let label = UILabel()
        label.text = "Label"
        label.textAlignment = .right
        label.textColor = .lightGray
        return label
    }()
    var notificationToLabel: UILabel = {
        let label = UILabel()
        label.text = "Label"
        label.textAlignment = .right
        label.textColor = .lightGray
        return label
    }()
    var notificationIntervalLabel: UILabel = {
        let label = UILabel()
        label.text = "Label"
        label.textAlignment = .right
        label.textColor = .lightGray
        return label
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for element in [smallPortionText, largePortionText, dailyGoalText] {
            element.inputAccessoryView = Globals.numericToolbar(element,
                                                                 selector: #selector(UIResponder.resignFirstResponder),
                                                                 barColor: .palette_main,
                                                                 textColor: .white)
        }
        
//        if WCSession.isSupported() {
//            WCSession.default.activate()
//        }
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        tableView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 40, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        updateUI()
    }
    
    func updateUI() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        var suffix = ""
        if let unit = Constants.UnitsOfMeasure(rawValue: userDefaults.integer(forKey: Constants.General.unitOfMeasure.key())) {
            unitOfMesureLabel.text = unit.nameForUnitOfMeasure()
            suffix = unit.suffixForUnitOfMeasure()
        }
        
        largePortionText.text = numberFormatter.string(for: userDefaults.double(forKey: Constants.Gulp.big.key()))! + suffix
        smallPortionText.text = numberFormatter.string(for: userDefaults.double(forKey: Constants.Gulp.small.key()))! + suffix
        dailyGoalText.text = numberFormatter.string(for: userDefaults.double(forKey: Constants.Gulp.goal.key()))! + suffix
        
        healthSwitch.isOn = userDefaults.bool(forKey: Constants.Health.on.key())
        
        notificationSwitch.isOn = userDefaults.bool(forKey: Constants.Notification.on.key())
        notificationFromLabel.text = "\(userDefaults.integer(forKey: Constants.Notification.from.key())):00"
        notificationToLabel.text = "\(userDefaults.integer(forKey: Constants.Notification.to.key())):00"
        notificationIntervalLabel.text = "\(userDefaults.integer(forKey: Constants.Notification.interval.key())) " +  NSLocalizedString("hours", comment: "")
    }
    
    func updateNotificationPreferences() {
        if (notificationSwitch.isOn) {
            NotificationHelper.unscheduleNotifications()
            NotificationHelper.askPermission()
        } else {
            NotificationHelper.unscheduleNotifications()
        }
    }
    
}

extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 3
        } else if section == 2 {
            if UserDefaults.groupUserDefaults().bool(forKey: Constants.Notification.on.key()) {
                return 4
            } else {
                return 1
            }
        } else if section == 3 {
            return 1
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Settings"
        } else if section == 1 {
            return "Portions"
        } else  if section == 2 {
            return "Notifications"
        } else  if section == 3 {
            return "Apple Health"
        } else {
            return "App Developer"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            cell.addSubview(unitOfMesureLabel)
            unitOfMesureLabel.anchor(cell.topAnchor, left: nil, bottom: cell.bottomAnchor, right: cell.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 100, heightConstant: 0)
            cell.textLabel?.text = NSLocalizedString("unit of measure title", comment: "")
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
                cell.addSubview(smallPortionText)
                smallPortionText.anchor(cell.topAnchor, left: nil, bottom: cell.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 100, heightConstant: 0)
                cell.textLabel?.text = NSLocalizedString("gulp.small", comment: "")
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
                cell.addSubview(largePortionText)
                largePortionText.anchor(cell.topAnchor, left: nil, bottom: cell.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 100, heightConstant: 0)
                cell.textLabel?.text = NSLocalizedString("gulp.big", comment: "")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
                cell.addSubview(dailyGoalText)
                dailyGoalText.anchor(cell.topAnchor, left: nil, bottom: cell.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 100, heightConstant: 0)
                cell.textLabel?.text = NSLocalizedString("Daily Goal", comment: "")
                return cell
            }
        }  else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
                cell.textLabel?.text = NSLocalizedString("remind me to drink", comment: "")
                cell.addSubview(notificationSwitch)
                notificationSwitch.anchor(cell.topAnchor, left: nil, bottom: cell.bottomAnchor, right: cell.rightAnchor, topConstant: 7.5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 0)
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
                cell.textLabel?.text = NSLocalizedString("from:", comment: "")
                cell.addSubview(notificationFromLabel)
                notificationFromLabel.anchor(cell.topAnchor, left: nil, bottom: cell.bottomAnchor, right: cell.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 100, heightConstant: 0)
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
                cell.textLabel?.text = NSLocalizedString("to:", comment: "")
                cell.addSubview(notificationToLabel)
                notificationToLabel.anchor(cell.topAnchor, left: nil, bottom: cell.bottomAnchor, right: cell.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 100, heightConstant: 0)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
                cell.textLabel?.text = NSLocalizedString("every:", comment: "")
                cell.addSubview(notificationIntervalLabel)
                notificationIntervalLabel.anchor(cell.topAnchor, left: nil, bottom: cell.bottomAnchor, right: cell.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 100, heightConstant: 0)
                return cell
            }
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            cell.addSubview(healthSwitch)
            healthSwitch.anchor(cell.topAnchor, left: nil, bottom: cell.bottomAnchor, right: cell.rightAnchor, topConstant: 7.5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 0)
            cell.textLabel?.text = NSLocalizedString("export.health", comment: "")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            cell.textLabel?.text = "Jakša Tomović"
            return cell
        }
    }
  
}


extension SettingsController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var actionSheet: AHKActionSheet?
        if ((indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 0) {
            actionSheet = AHKActionSheet(title: NSLocalizedString("unit of measure title", comment: ""))
            actionSheet?.addButton(withTitle: Constants.UnitsOfMeasure.liters.nameForUnitOfMeasure(), type: .default) { _ in
                self.userDefaults.set(Constants.UnitsOfMeasure.liters.rawValue, forKey: Constants.General.unitOfMeasure.key())
                self.userDefaults.synchronize()
                self.updateUI()
            }
            actionSheet?.addButton(withTitle: Constants.UnitsOfMeasure.ounces.nameForUnitOfMeasure(), type: .default) { _ in
                self.userDefaults.set(Constants.UnitsOfMeasure.ounces.rawValue, forKey: Constants.General.unitOfMeasure.key())
                self.userDefaults.synchronize()
                self.updateUI()
            }
        }
        if ((indexPath as NSIndexPath).section == 2 && (indexPath as NSIndexPath).row == 1) {
            actionSheet = AHKActionSheet(title: NSLocalizedString("from:", comment: ""))
            for index in 5...22 {
                actionSheet?.addButton(withTitle: "\(index):00", type: .default) { _ in
                    self.updateNotificationSetting(Constants.Notification.from.key(), value: index)
                }
            }
        }
        if ((indexPath as NSIndexPath).section == 2 && (indexPath as NSIndexPath).row == 2) {
            actionSheet = AHKActionSheet(title: NSLocalizedString("to:", comment: ""))
            let upper = self.userDefaults.integer(forKey: Constants.Notification.from.key()) + 1
            for index in upper...24 {
                actionSheet?.addButton(withTitle: "\(index):00", type: .default) { _ in
                    self.updateNotificationSetting(Constants.Notification.to.key(), value: index)
                }
            }
        }
        if ((indexPath as NSIndexPath).section == 2 && (indexPath as NSIndexPath).row == 3) {
            actionSheet = AHKActionSheet(title: NSLocalizedString("every:", comment: ""))
            for index in 1...8 {
                let hour = index > 1 ? NSLocalizedString("hours", comment: "") : NSLocalizedString("hour", comment: "")
                actionSheet?.addButton(withTitle: "\(index) \(hour)", type: .default) { _ in
                    self.updateNotificationSetting(Constants.Notification.interval.key(), value: index)
                }
            }
        }
        actionSheet?.show()
    }
    
    func updateNotificationSetting(_ key: String, value: Int) {
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
        updateUI()
        updateNotificationPreferences()
    }
    

    
    @objc func healthAction(_ sender: UISwitch) {
        userDefaults.set(sender.isOn, forKey: Constants.Health.on.key())
        userDefaults.synchronize()
        self.tableView.reloadData()
        if sender.isOn {
//            HealthKitHelper.sharedHelper.askPermission()
        }
    }
    
    @objc func reminderAction(_ sender: UISwitch) {
        userDefaults.set(sender.isOn, forKey: Constants.Notification.on.key())
        userDefaults.synchronize()
        self.tableView.reloadData()
        updateNotificationPreferences()
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == smallPortionText) {
            storeText(smallPortionText, toKey: Constants.Gulp.small.key())
        }
        if (textField == largePortionText) {
            storeText(largePortionText, toKey: Constants.Gulp.big.key())
        }
        if (textField == dailyGoalText) {
            storeText(dailyGoalText, toKey: Constants.Gulp.goal.key())
        }
    }
    
    func storeText(_ textField: UITextField, toKey key: String) {
        guard let text = textField.text else {
            return
        }
        let number = numberFormatter.number(from: text) as? Double
        userDefaults.set(number ?? 0.0, forKey: key)
        userDefaults.synchronize()
        
        // Update the settings on the watch
//        WatchConnectivityHelper().sendWatchData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return Globals.numericTextField(textField, shouldChangeCharactersInRange: range, replacementString: string)
    }
}


