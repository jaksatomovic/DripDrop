

import UIKit

class HelpController: UIViewController {
    
    let userDefaults = UserDefaults.groupUserDefaults()


    override func viewDidLoad() {
        super.viewDidLoad()
    }


    
    @IBAction func doneAction() {
        self.userDefaults.set(true, forKey: Constants.Notification.on.key())
        userDefaults.set(true, forKey: Constants.General.onboardingShown.key())
        NotificationHelper.unscheduleNotifications()
        self.userDefaults.synchronize()
        NotificationHelper.askPermission()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.loadMainInterface()
        }
    }
    
    @IBAction func tapBack(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
