//
//  AppDelegate.swift
//  DripDrop
//
//  Created by Jaksa Tomovic on 22/02/2018.
//  Copyright © 2018 Jaksa Tomovic. All rights reserved.
//

import UIKit
import SwipeTransition

class SwipeNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeBack = SwipeBackController(navigationController: self)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var controller: SLPagingViewSwift!

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
//            checkVersion()
        }
        
        return true
    }
    
    
    /**
     Sets the swipe menu of the app
     */
    func setupSwipeMenu() {
        let vc1 = ProgressController()
        let vc2 = MainController()
        let vc3 = SettingsController()
        
        let img1 = #imageLiteral(resourceName: "calendar-icon").withRenderingMode(.alwaysTemplate)
        let img2 = #imageLiteral(resourceName: "drink-icon").withRenderingMode(.alwaysTemplate)
        let img3 = #imageLiteral(resourceName: "settings-icon").withRenderingMode(.alwaysTemplate)
        
        let items = [UIImageView(image: img1), UIImageView(image: img2), UIImageView(image: img3)]
        let controllers = [vc1, vc2, vc3]
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
        
        self.window?.rootViewController = UINavigationController(rootViewController: self.controller)
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
        let vc = MainController()
        self.window?.rootViewController = SwipeNavigationController(rootViewController: vc)
//        self.window?.rootViewController = UINavigationController(rootViewController: vc)
    }
    
}

