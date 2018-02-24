//
//  Entry.swift
//  DripDrop
//
//  Created by Jaksa Tomovic on 23/02/2018.
//  Copyright © 2018 Jaksa Tomovic. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    /**
     Adds a portion of water to the current day
     - parameter quantity: The portion size
     - parameter goal: The daily goal
     - parameter date: The date of the portion
     */
//    func addGulp(_ quantity: Double, goal: Double, date: Date) {
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//        let gulp = NSEntityDescription.insertNewObject(forEntityName: "Gulp", into: context) as! Gulp
//        var entry = EntryHandler.sharedHandler.entryForDate(date)
//        if entry == nil {
//            entry = EntryHandler.sharedHandler.createEntryForDate(date)
//        } else {
//            entry = EntryHandler.sharedHandler.currentEntry()
//        }
//
//        gulp.entry = entry
//        gulp.date = date
//        gulp.quantity = quantity
//        entry?.quantity += quantity
//        entry?.goal = goal
//        entry?.date = date
//        if goal > 0 {
//            entry?.percentage = ((entry?.quantity)! / (entry?.goal)!) * 100.0
//        }
//        do {
//            print(entry as Any)
//            try context.save()
//        } catch let saveErr {
//            print("Failed to save company:", saveErr)
//        }
//    }
    
    /**
     Removes the last portion
     */
//    func removeLastGulp() {
//        if let gulp = self.gulps.last {
//            self.quantity -= gulp.quantity
//            if goal > 0 {
//                self.percentage = (self.quantity / self.goal) * 100.0
//            }
//            if (self.percentage < 0) {
//                self.percentage = 0
//            }
//            self.gulps.removeLast()
//        }
//    }
    
    /**
     Returns the formatted percentage value
     - returns: String
     */
    func formattedPercentage() -> String {
        return percentage.formattedPercentage()
    }
}
