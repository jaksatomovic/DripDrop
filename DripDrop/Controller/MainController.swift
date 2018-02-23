//
//  ViewController.swift
//  DripDrop
//
//  Created by Jaksa Tomovic on 22/02/2018.
//  Copyright © 2018 Jaksa Tomovic. All rights reserved.
//

import UIKit
import BAFluidView
import UICountingLabel
import BubbleTransition
import CoreMotion

open class MainController: UIViewController, UIAlertViewDelegate, UIViewControllerTransitioningDelegate {
    
    var percentageLabel: UICountingLabel = {
        let label = UICountingLabel()
        label.text = "50"
        label.textColor = Palette.palette_main
        label.textAlignment = .center
        label.font = UIFont.init(name: "KaushanScript-Regular", size: 34.0)
        return label
    }()
    var addButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "small-tiny-icon"), for: .normal)
        button.backgroundColor = Palette.palette_main
        return button
    }()
//    @IBOutlet open weak var smallButton: UIButton!
//    @IBOutlet open weak var largeButton: UIButton!
//    @IBOutlet open weak var minusButton: UIButton!
//    @IBOutlet weak var starButton: UIButton!
    var meterContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    var maskImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "glass").withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    open var userDefaults = UserDefaults.groupUserDefaults()
    open var progressMeter: BAFluidView?
    var expanded = false
    let transition = BubbleTransition()
    let manager = CMMotionManager()
    
    // MARK: - Life cycle
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
// Ask (just once) the user for feedback once he's logged more than 10 liters/ounces
//        if !userDefaults.bool(forKey: "FEEDBACK") {
//            if EntryHandler.sharedHandler.overallQuantity() > 10 {
//                animateStarButton()
//            }
//        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        view.layoutIfNeeded()
        initProgressMeter()

        
        percentageLabel.animationDuration = 1.5
        percentageLabel.format = "%d%%";
        
        manager.accelerometerUpdateInterval = 0.01
        manager.deviceMotionUpdateInterval = 0.01;
        manager.startDeviceMotionUpdates(to: OperationQueue.main) {
            (motion, error) in
            if let motion = motion {
                let roation = atan2(motion.gravity.x, motion.gravity.y) - Double.pi
                self.progressMeter?.transform = CGAffineTransform(rotationAngle: CGFloat(roation))
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(percentageLabel)
        view.addSubview(addButton)
        view.addSubview(meterContainerView)
        
        percentageLabel.anchor(nil, left: view.leftAnchor, bottom: meterContainerView.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 30, rightConstant: 0, widthConstant: 0, heightConstant: 60)
        
        meterContainerView.anchor(view.centerYAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: -view.frame.width/2, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.width)
        meterContainerView.addSubview(maskImage)
        maskImage.fillSuperview()
        
        addButton.anchor(meterContainerView.bottomAnchor, left: view.centerXAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: -25, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        
    }
    
    func initProgressMeter() {
        if progressMeter == nil {
            let width = meterContainerView.frame.size.width
            progressMeter = BAFluidView(frame: CGRect(x: 0, y: 0, width: width, height: width), maxAmplitude: 40, minAmplitude: 8, amplitudeIncrement: 1)
            progressMeter!.backgroundColor = .clear
            progressMeter!.fillColor = .palette_main
            progressMeter!.fillAutoReverse = false
            progressMeter!.fillDuration = 1.5
            progressMeter!.fillRepeatCount = 0
            meterContainerView.insertSubview(progressMeter!, belowSubview: maskImage)
            
            updateUI()
        }
    }
    
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Globals.showPopTipOnceForKey("HEALTH_HINT", userDefaults: userDefaults,
                                     popTipText: NSLocalizedString("health.poptip", comment: ""),
                                     inView: view,
                                     fromFrame: CGRect(x: view.frame.width - 60, y: view.frame.height, width: 1, height: 1), direction: .up, color: .palette_destructive)
    }
    
    // MARK: - UI update
    
    func updateCurrentEntry(_ delta: Double) {
//        EntryHandler.sharedHandler.addGulp(delta)
    }
    
    @objc func updateUI() {
        let percentage = 90.0 //EntryHandler.sharedHandler.currentPercentage()
        percentageLabel.countFromCurrentValue(to: CGFloat(round(percentage)))
        var fillTo = Double(percentage / 100.0)
        if fillTo > 1 {
            fillTo = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.progressMeter?.fill(to: NSNumber(value: fillTo))
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func removeGulpAction() {
        let controller = UIAlertController(title: NSLocalizedString("undo title", comment: ""), message: NSLocalizedString("undo message", comment: ""), preferredStyle: .alert)
        let no = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default) { _ in }
        let yes = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .cancel) { _ in
//            EntryHandler.sharedHandler.removeLastGulp()
        }
        [yes, no].forEach { controller.addAction($0) }
        present(controller, animated: true) {}
    }
    
    // MARK: - Tear down
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

