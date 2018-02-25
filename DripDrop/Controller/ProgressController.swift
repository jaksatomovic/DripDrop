//
//  ProgressController.swift
//  DripDrop
//
//  Created by Jaksa Tomovic on 22/02/2018.
//  Copyright © 2018 Jaksa Tomovic. All rights reserved.
//

import UIKit
import CVCalendar
import pop
import UICountingLabel
import AHKActionSheet

class ProgressController: UIViewController {
    let userDefaults = UserDefaults.groupUserDefaults()
    
    var calendarMenu: CVCalendarMenuView = {
        let view = CVCalendarMenuView()
        view.backgroundColor = .white
        return view
    }()
    var calendarContent: CVCalendarView = {
        let view = CVCalendarView()
        view.backgroundColor = .white
        return view
    }()
    
    var percentageLabel: UICountingLabel = {
        let label = UICountingLabel()
        label.text = "50"
        label.textColor = Palette.palette_main
        label.textAlignment = .center
        label.font = UIFont.init(name: "KaushanScript-Regular", size: 34.0)
        return label
    }()
    
//    var addButton: UIButton = {
//        let button = UIButton()
//        button.layer.cornerRadius = 10
//        button.clipsToBounds = true
//        button.backgroundColor = .clear
//        button.setImage(#imageLiteral(resourceName: "tiny-add").withRenderingMode(.alwaysOriginal), for: .normal)
//        button.addTarget(self, action: #selector(addGulp), for: .touchUpInside)
//        return button
//    }()
    
    var shareButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.backgroundColor = .clear
        button.backgroundColor = Palette.palette_main
        button.tintColor = .white
        button.setImage(#imageLiteral(resourceName: "Upload").withRenderingMode(.alwaysTemplate), for: .normal)
//        button.addTarget(self, action: #selector(ProgressController.addButtonPressed), for: .touchUpInside)
        return button
    }()
    
//    lazy var actionSheet: AHKActionSheet = {
//        var actionSheet = AHKActionSheet(title: NSLocalizedString("portion.add", comment: ""))
//        actionSheet?.addButton(withTitle: NSLocalizedString("gulp.small", comment: ""), type: .default) { _ in
//            self.addExtraGulp(ofSize: .small)
////            let vc = MainController()
////            vc.updateUI()
//        }
//        actionSheet?.addButton(withTitle: NSLocalizedString("gulp.big", comment: ""), type: .default) { _ in
//            self.addExtraGulp(ofSize: .big)
////            let vc = MainController()
////            vc.updateUI()
//        }
//        return actionSheet!
//    }()
    
    let shareExclusions = [
        UIActivityType.airDrop, UIActivityType.assignToContact, UIActivityType.addToReadingList,
        UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.postToVimeo, UIActivityType.postToTencentWeibo
    ]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        Globals.showPopTipOnceForKey("SHARE_HINT", userDefaults: userDefaults,
//                                     popTipText: NSLocalizedString("share poptip", comment: ""),
//                                     inView: view,
//                                     fromFrame: CGRect(x: view.frame.size.width - 28, y: -10, width: 1, height: 1))
        
//        updateStats()
        percentageLabel.text = dateLabelString(Date())
        calendarContent.contentController.refreshPresentedMonth()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        percentageLabel.animationDuration = 1.5
        percentageLabel.format = "%d%%";
        
        setupCalendar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateCalendarView()
    }
    
    fileprivate func updateCalendarView() {
        calendarMenu.commitMenuViewUpdate()
        calendarContent.commitCalendarViewUpdate()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
//        view.addSubview(addButton)
//        view.addSubview(shareButton)
        view.addSubview(percentageLabel)
        view.addSubview(calendarContent)
        view.addSubview(calendarMenu)
        
        calendarMenu.anchor(view.topAnchor, left: view.leftAnchor, bottom: calendarContent.topAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 15)
        calendarContent.anchor(calendarMenu.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 300)
        
        percentageLabel.anchor(calendarContent.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
//        addButton.anchor(percentageLabel.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 20, heightConstant: 20)
        
//        shareButton.anchor(percentageLabel.bottomAnchor, left: view.centerXAnchor, bottom: nil, right: nil, topConstant: 50, leftConstant: -25, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        
    }
    
//    @objc func addGulp() {
//        actionSheet.show()
//    }
//
//    func addExtraGulp(ofSize: Constants.Gulp) {
//        let selectedDate = calendarContent.coordinator.selectedDayView?.date.convertedDate()
//        CoreDataManager.shared.addExtraGulp(size: UserDefaults.groupUserDefaults().double(forKey: ofSize.key()), date: selectedDate!)
//        updateCalendarView()
//        if let date = selectedDate {
//            percentageLabel.text = dateLabelString(date)
//        } else {
//            percentageLabel.text = dateLabelString(Date())
//        }
//    }
    
}


extension ProgressController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate, CVCalendarViewAppearanceDelegate {
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    func firstWeekday() -> Weekday {
        return .monday
    }
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        guard let date = dayView.date.convertedDate() else {
            return
        }
        percentageLabel.text = dateLabelString(date)
    }
    
    func latestSelectableDate() -> Date {
        return Date()
    }
    
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        guard let percentage = percentage(for: dayView.date.convertedDate()) else { return false }
        
        return percentage > 0.0
    }
    
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        guard let percentage = percentage(for: dayView.date.convertedDate()) else { return [] }
        
        return percentage >= 1.0 ? [.palette_main] : [.palette_destructive]
    }
    
    fileprivate func percentage(for date: Date?) -> Double? {
        guard let date = date,
            let entry = CoreDataManager.shared.entryForDate(date) else {
                return nil
        }
        print("\(entry.percentage / 100.0)")
        return Double(entry.percentage / 100.0)
    }
    
    func dayLabelWeekdaySelectedBackgroundColor() -> UIColor {
        return .palette_main
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        print(date.globalDescription)
    }
}

extension ProgressController {
    func setupCalendar() {
        calendarMenu.menuViewDelegate = self
        calendarContent.calendarDelegate = self
        calendarContent.calendarAppearanceDelegate = self
        
//        monthLabel.text = CVDate(date: Date()).globalDescription
//        if let font = UIFont(name: "KaushanScript-Regular", size: 16) {
//            monthLabel.font = font
//            monthLabel.textAlignment = .center
//            monthLabel.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00)
//        }
    }
    
//    func updateStats() {
//        daysCountLabel.countFromZero(to: CGFloat(EntryHandler.sharedHandler.daysTracked()))
//        quantityLabel.countFromZero(to: CGFloat(EntryHandler.sharedHandler.overallQuantity()))
//        measureLabel.text = String(format: NSLocalizedString("unit format", comment: ""), unitName())
//    }
    
    func unitName() -> String {
        if let unit = Constants.UnitsOfMeasure(rawValue: userDefaults.integer(forKey: Constants.General.unitOfMeasure.key())) {
            return unit.nameForUnitOfMeasure()
        }
        return ""
    }
    
    func dateLabelString(_ date: Date = Date()) -> String {
        print(date)
        if let entry = CoreDataManager.shared.entryForDate(date) {
            if (entry.percentage >= 100) {
                return NSLocalizedString("goal met", comment: "")
            } else {
                return entry.formattedPercentage()
            }
        } else {
            return ""
        }
    }
}
