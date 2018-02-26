//
//  AppDelegate.swift
//  DripDrop
//
//  Created by Jaksa Tomovic on 22/02/2018.
//  Copyright © 2018 Jaksa Tomovic. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var controller: SLPagingViewSwift!
    var vc1: UIViewController!
    var vc2: UIViewController!
    var vc3: UIViewController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        setupAppearance()
        Settings.registerDefaults()
//        watchConnectivityHelper.setupWatchConnectivity(delegate: self)
        
        let userDefaults = UserDefaults.groupUserDefaults()
        if (!userDefaults.bool(forKey: Constants.General.onboardingShown.key())) {
            loadOnboardingInterface()
        } else {
            setupSwipeMenu()
            checkVersion()
        }
        
        return true
    }
    
    
    /**
     Check the app version and perform required tasks when upgrading
     */
    func checkVersion() {
        let userDefaults = UserDefaults.groupUserDefaults()
        let current = userDefaults.integer(forKey: "BUNDLE_VERSION")
        if let versionString = Bundle.main.infoDictionary?["CFBundleVersion"] as? String, let version = Int(versionString) {
            if current < 13 {
                NotificationHelper.rescheduleNotifications()
            }
            userDefaults.set(version, forKey: "BUNDLE_VERSION")
            userDefaults.synchronize()
        }
    }
    
    
    /**
     Sets the swipe menu of the app
     */
    func setupSwipeMenu() {
        
        vc1 = ProgressController()
        vc2 = MainController()
        vc3 = SettingsController()
        
        let img1 = #imageLiteral(resourceName: "calendar-icon").withRenderingMode(.alwaysTemplate)
        let img2 = #imageLiteral(resourceName: "big").withRenderingMode(.alwaysOriginal)
        let img3 = #imageLiteral(resourceName: "Settings").withRenderingMode(.alwaysTemplate)
        
        let items = [UIImageView(image: img1), UIImageView(image: img2), UIImageView(image: img3)]
        let controllers: [UIViewController] = [vc1, vc2, vc3]
        controller = SLPagingViewSwift(items: items, controllers: controllers, showPageControl: false)
        
        controller.pagingViewMoving = ({ subviews in
            if let imageViews = subviews as? [UIImageView] {
                for imgView in imageViews {
                    var c = UIColor.gray
                    let originX = Double(imgView.frame.origin.x)
                    if (originX > 45 && originX < 145) {
                        c = UIColor.gray
                    }
                    else if (originX > 145 && originX < 245) {
                        c = Palette.palette_main
                    }
                    else if(originX == 145){
                        c = UIColor.gray
                    }
                    imgView.tintColor = c
                }
            }
        })
        
        self.window?.rootViewController = SwipeNavigationController(rootViewController: self.controller)
    }
    
 

    /**
     Sets the main appearance of the app
     */
    func setupAppearance() {
        Globals.actionSheetAppearance()
        
        UITabBar.appearance().tintColor = .palette_main
        
        if let font = UIFont(name: "KaushanScript-Regular", size: 22) {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.palette_main]
        }
        
        UINavigationBar.appearance().barTintColor = .palette_main
        UINavigationBar.appearance().tintColor = .white
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.white
        }
    
    }

    /**
     Present the onboarding controller if needed
     */
    func loadOnboardingInterface() {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let controller = storyboard.instantiateInitialViewController() {
            self.window?.rootViewController = controller
        }
    }
    
    /**
     Present the main interface
     */
    func loadMainInterface() {
//        realmNotification = watchConnectivityHelper.setupWatchUpdates()
        setupSwipeMenu()
    }
    
}

