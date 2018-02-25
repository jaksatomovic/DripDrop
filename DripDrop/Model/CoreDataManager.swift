//
//  CoreDataManager.swift
//  DripDrop
//
//  Created by Jaksa Tomovic on 23/02/2018.
//  Copyright © 2018 Jaksa Tomovic. All rights reserved.
//

import CoreData
import CVCalendar

struct CoreDataManager {
    
    static let shared = CoreDataManager() // will live forever as long as your application is still alive, it's properties will too
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModels")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    
//    open func addGulp(_ quantity: Double, date: Date) {
//        //        HealthKitHelper.sharedHelper.saveSample(quantity, date: date)
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//        let gulp = NSEntityDescription.insertNewObject(forEntityName: "Gulp", into: context) as! Gulp
//        var entry = Entry(context: context)
//
//        if gulp.entry == nil {
//            entry = createEntryForDate(date)
//            print ("ENTRY FOR DATE: \(entry)")
//        } else {
//            entry = currentEntry()
//            print ("CURRENT: \(entry)")
//        }
//        do {
//            entry.addGulp(quantity, goal: self.userDefaults.double(forKey: Constants.Gulp.goal.key()), date: date)
//            try context.save()
//        } catch let saveErr {
//            print("Failed to save company:", saveErr)
//        }
//
//    }
    
    func addGulp(quantity: Double) {
//        HealthKitHelper.sharedHelper.saveSample(quantity, date: date)
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let gulp = NSEntityDescription.insertNewObject(forEntityName: "Gulp", into: context) as! Gulp
        var entry = CoreDataManager.shared.entryForDate(Date())
        
        if entry == nil {
            print("creating new entry")
            entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: context) as? Entry
        }

        let date = Date()
        entry?.date = date
        entry?.quantity += quantity
        entry?.goal = 2.0
        entry?.percentage = ((entry?.quantity)! / (entry?.goal)!) * 100.0
        
        
        gulp.date = date
        gulp.quantity = quantity
        
        gulp.entry = entry
        
        do {
            try context.save()
            
        } catch let saveErr {
            print("Failed to save entry:", saveErr)
        }
    }
    
    func addExtraGulp(size: Double, date: Date) {
//        HealthKitHelper.sharedHelper.saveSample(quantity, date: date)
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let gulp = NSEntityDescription.insertNewObject(forEntityName: "Gulp", into: context) as! Gulp
        var entry = CoreDataManager.shared.entryForDate(Date())
        
        if entry == nil {
            print("creating new entry")
            entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: context) as? Entry
        }
        
        let date = Date()
        entry?.date = date
        entry?.quantity += size
        entry?.goal = 2.0
        entry?.percentage = ((entry?.quantity)! / (entry?.goal)!) * 100.0
        
        
        gulp.date = date
        gulp.quantity = size
        
        gulp.entry = entry
        
        do {
            try context.save()
            
        } catch let saveErr {
            print("Failed to save entry:", saveErr)
        }
    }
    
    func createEntryForDate(_ date: Date) -> Entry {
        let contex = CoreDataManager.shared.persistentContainer.viewContext
        let newEntry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: contex) as! Entry
        newEntry.date = date
        do {
            try contex.save()
        } catch let saveErr {
            print("Failed to save entry:", saveErr)
        }
        return newEntry

    }

    func entryForToday() -> Entry? {
        return entryForDate(Date())
    }
    
    func currentEntry() -> Entry {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if let entry = entryForToday() {
            return entry
        } else {
            let newEntry = Entry(context: context)
            do {
                try context.save()
            } catch let saveErr {
                print("Failed to save entry:", saveErr)
            }
            return newEntry
        }
    }

    
  
    
    
    func entryForDate(_ date: Date) -> Entry? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        var result = [Entry]()
        
        
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
    
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)

        let predicate = NSPredicate(format: "date >= %@ AND date < %@", startDate as! CVarArg, endDate! as CVarArg)
        request.predicate = predicate

        do {
            result = try context.fetch(request)
            return result.first
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return nil
    }

    
//    func fetchEntries() -> [Entry] {
//        let context = persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
//        do {
//            let entries = try context.fetch(fetchRequest)
//            print("--------------------------------")
//            for i in entries {
//                for x in i.gulps! {
//                    print ("OVO JE GULP: \(x) ")
//                }
//            }
//            return entries
//        } catch let fetchErr {
//            print("Failed to fetch companies:", fetchErr)
//            return []
//        }
//    }

    func currentPercentage() -> Double {
        return currentEntry().percentage
    }
    
   
    
    
    func removeLastGulp() {
//        HealthKitHelper.sharedHelper.removeLastSample()
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let entry = currentEntry()
        if let gulps = entry.gulps {
            let index = gulps.count - 1
            if index >= 0 {
                let lastGulp = gulps.allObjects[index] as! Gulp
                entry.quantity -= lastGulp.quantity
                if entry.goal > 0 {
                    entry.percentage = (entry.quantity / entry.goal) * 100.0
                }
                
                if (entry.percentage < 0) {
                    entry.percentage = 0
                }
                
                context.delete(lastGulp)
                do {
                    try context.save()
                    print("gulp deleted")
                } catch let saveErr {
                    print("Failed to delete gulp:", saveErr)
                }
            }
        }
    }

    func overallQuantity() -> Double {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        var sum: Double = 0.0
        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
        
        do {
            let entries = try context.fetch(fetchRequest)
            entries.forEach({ (entry) in
                sum += entry.quantity
            })
            
        } catch let fetchErr {
            print("Failed to fetch entry:", fetchErr)
        }
        
        return sum
    }
 
    func daysTracked() -> Int {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        var count: Int = 0
        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
        
        do {
            let entries = try context.fetch(fetchRequest)
            
            entries.forEach({ (entry) in
                count += 1
            })
            
        } catch let fetchErr {
            print("Failed to fetch entry:", fetchErr)
        }
        return count
    }
    
}
