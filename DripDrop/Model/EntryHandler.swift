//
//  EntryHandler.swift
//  DripDrop
//
//  Created by Jaksa Tomovic on 23/02/2018.
//  Copyright © 2018 Jaksa Tomovic. All rights reserved.
//

import CoreData

/**
 Helper singleton to perform operations on the Realm database
 */
open class EntryHandler: NSObject {
    
    open static let sharedHandler = EntryHandler()
    open lazy var userDefaults = UserDefaults.groupUserDefaults()
    
    open func createEntryForDate(_ date: Date) -> Entry {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let newEntry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: context)
        newEntry.setValue( date, forKey: "date")
        do {
            try context.save()
        } catch let saveErr {
            print("Failed to save company:", saveErr)
        }
        print(newEntry)
        return newEntry as! Entry
    }
    
    /**
     Returns the current entry
     - returns: Entry?
     */
    open func entryForToday() -> Entry? {
        return entryForDate(Date())
    }
    
    /**
     Returns an entry for the given date
     - parameter date: The desired date
     - returns: Entry?
     */
    open func entryForDate(_ date: Date) -> Entry? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        var result = [Any]()

        let request = NSFetchRequest<Entry>(entityName: "Entry")
        let p: NSPredicate = NSPredicate(format: "date == %@", argumentArray: [ date ])
        request.predicate = p
        request.returnsObjectsAsFaults = false
        do {
            result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "date") )
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return result.first as? Entry
    }
    
    /**
     Returns the current entry if available, or creates a new one instead
     - returns: Entry
     */
    open func currentEntry() -> Entry {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if let entry = entryForToday() {
            print(entry)
            return entry
        } else {
            let newEntry = Entry(context: context)
            do {
                try context.save()
            } catch let saveErr {
                print("Failed to save company:", saveErr)
            }
            print(newEntry)
            return newEntry
        }
    }
    
    /**
     Gets the current percentage
     - returns: Double
     */
    open func currentPercentage() -> Double {
        return currentEntry().percentage
    }
    
    /**
     Adds a portion to the current entry. If available, the sample is saved in HealthKit as well
     - parameter quantity: The sample value
     */
    open func addGulp(_ quantity: Double) {
        addGulp(quantity, date: Date())
    }
    
    /**
     Adds a portion to the current entry for a given date. If available, the sample is saved in HealthKit as well
     - parameter quantity: The sample value
     - parameter date: The sample date
     */
    open func addGulp(_ quantity: Double, date: Date) {
//        HealthKitHelper.sharedHelper.saveSample(quantity, date: date)
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let gulp = NSEntityDescription.insertNewObject(forEntityName: "Gulp", into: context) as! Gulp
        var entry = Entry(context: context)

        if gulp.entry == nil {
            entry = createEntryForDate(date)
            print ("ENTRY FOR DATE: \(entry)")
        } else {
            entry = currentEntry()
            print ("CURRENT: \(entry)")
        }
        do {
            entry.addGulp(quantity, goal: self.userDefaults.double(forKey: Constants.Gulp.goal.key()), date: date)
            try context.save()
        } catch let saveErr {
            print("Failed to save company:", saveErr)
        }
        
    }
    
    /**
     Removes the last portion to the current entry. If available, the sample is removed in HealthKit as well
     */
    
    /**
     Returns the value of all the portions recorded
     - returns: Double
     */
//    open func overallQuantity() -> Double {
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//        var sum: Double = 0.0
//        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
//
//        do {
//            let entries = try context.fetch(fetchRequest)
//
//            entries.forEach({ (entry) in
//                print(entry.quantity )
//                sum += entry.quantity
//            })
//
//        } catch let fetchErr {
//            print("Failed to fetch companies:", fetchErr)
//        }
//
//        return sum
//    }
    
    /**
     Returns the value number of days tracked
     - returns: Int
     */
//    open func daysTracked() -> Int {
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//        var count: Int = 0
//        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
//
//        do {
//            let entries = try context.fetch(fetchRequest)
//
//            entries.forEach({ (entry) in
//                count += 1
//            })
//
//        } catch let fetchErr {
//            print("Failed to fetch companies:", fetchErr)
//        }
//        return count
//    }
}
