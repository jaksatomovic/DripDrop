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
import CoreData


class MainController: UIViewController, UIAlertViewDelegate {
    
    
    
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
        button.layer.borderColor = Palette.palette_main.cgColor
        button.layer.borderWidth = 2
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.isEnabled = true
        button.tintColor = Palette.palette_main
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
        button.setTitle("Drink", for: .normal)
        button.setTitleColor(Palette.palette_main, for: .normal)
        button.addTarget(self, action: #selector(MainController.addButtonPressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(MainController.addButtonTouched), for: .touchDown)
        return button
    }()
    
    var starButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.isEnabled = true
        button.setImage(#imageLiteral(resourceName: "star").withRenderingMode(.alwaysOriginal), for: .normal)
//        button.addTarget(self, action: #selector(MainController.drinkButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    var minusButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        button.setImage(#imageLiteral(resourceName: "minus-icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(MainController.removeGulpAction), for: .touchUpInside)
        return button
    }()

    var meterContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
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
        if !userDefaults.bool(forKey: "FEEDBACK") {
            if CoreDataManager.shared.overallQuantity() > 10 {
//                animateStarButton()
                print("ANIMATING STAR BUTTON")
            }
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Globals.showPopTipOnceForKey("HEALTH_HINT", userDefaults: userDefaults,
                                     popTipText: NSLocalizedString("health.poptip", comment: ""),
                                     inView: view,
                                     fromFrame: CGRect(x: view.frame.width - 60, y: 50, width: 1, height: 1), direction: .down, color: .palette_destructive)
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
    
    
    // MARK: - UI Layout
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(percentageLabel)
        view.addSubview(starButton)
        view.addSubview(minusButton)
        view.addSubview(meterContainerView)
        view.addSubview(addButton)
        view.bringSubview(toFront: addButton)

        starButton.isHidden = true
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_ :)))
        longGesture.minimumPressDuration = 1
        addButton.addGestureRecognizer(longGesture)

        
        starButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        
        minusButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 20, heightConstant: 20)
        
        percentageLabel.anchor(nil, left: view.leftAnchor, bottom: meterContainerView.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 30, rightConstant: 0, widthConstant: 0, heightConstant: 60)
        
        meterContainerView.anchor(view.centerYAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: -view.frame.width/2 - 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.width)
        meterContainerView.addSubview(maskImage)
        maskImage.fillSuperview()
        
        addButton.anchor(meterContainerView.bottomAnchor, left: view.centerXAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: -50, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 50)
        
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
    
    
 
    
    // MARK: - UI update
    
    func updateCurrentEntry(_ delta: Double) {
        CoreDataManager.shared.addGulp(quantity: delta)
        updateUI()
    }
    
    @objc func updateUI() {
        let percentage = CoreDataManager.shared.currentPercentage()
        percentageLabel.countFromCurrentValue(to: CGFloat(round(percentage)))
        var fillTo = Double(percentage / 100.0)
        if CGFloat(round(percentage)) == 0 {
            minusButton.isHidden = true
        } else {
            minusButton.isHidden = false
        }
        if fillTo > 1 {
            fillTo = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.progressMeter?.fill(to: NSNumber(value: fillTo))
        }
    }
    
    // MARK: - Actions
    

    
    @objc func removeGulpAction() {
        let controller = UIAlertController(title: NSLocalizedString("undo title", comment: ""), message: NSLocalizedString("undo message", comment: ""), preferredStyle: .alert)
        let no = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default) { _ in }
        let yes = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .cancel) { _ in
            CoreDataManager.shared.removeLastGulp()
            self.updateUI()
        }
        [yes, no].forEach { controller.addAction($0) }
        present(controller, animated: true) {}
    }

    @objc func addButtonPressed() {
        addButton.setTitleColor(Palette.palette_main, for: .normal)
        addButton.backgroundColor = .white
        Globals.showPopTipOnceForKey("UNDO_HINT", userDefaults: userDefaults,
                                     popTipText: NSLocalizedString("undo poptip", comment: ""),
                                     inView: view,
                                     fromFrame: minusButton.frame)
        Globals.showPopTipOnceForKey("LONG_PRESS_HINT", userDefaults: userDefaults,
                                     popTipText: NSLocalizedString("long press poptip", comment: ""),
                                     inView: view,
                                     fromFrame: addButton.frame)
        let portion = Constants.Gulp.small.key()
        updateCurrentEntry(userDefaults.double(forKey: portion))
        
    }
    
  
     @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        
        if (sender.state == UIGestureRecognizerState.ended) {
            print("Long press Ended");
        } else if (sender.state == UIGestureRecognizerState.began) {
            print("Long press detected.");
            addButton.setTitleColor(Palette.palette_main, for: .normal)
            addButton.backgroundColor = .white
            let portion = Constants.Gulp.big.key()
            updateCurrentEntry(userDefaults.double(forKey: portion))
        }
    }

    @objc func addButtonTouched() {
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.backgroundColor = Palette.palette_main
    }
 
    
    // MARK: - Tear down
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


