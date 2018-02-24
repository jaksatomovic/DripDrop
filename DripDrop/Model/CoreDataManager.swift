//
//  CoreDataManager.swift
//  DripDrop
//
//  Created by Jaksa Tomovic on 23/02/2018.
//  Copyright © 2018 Jaksa Tomovic. All rights reserved.
//

import CoreData

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
    
    
    func addGulp(quantity: Double) {
//        HealthKitHelper.sharedHelper.saveSample(quantity, date: date)
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let gulp = NSEntityDescription.insertNewObject(forEntityName: "Gulp", into: context) as! Gulp
        var entry = CoreDataManager.shared.entryForDate(Date())
        
        if entry == nil {
            print("radim novi entry")
            entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: context) as? Entry
        }

        let date = Date()
        entry?.date = date
        entry?.quantity += quantity
        entry?.goal = 2.0
        entry?.percentage = ((entry?.quantity)! / (entry?.goal)!) * 100.0
        
        
        gulp.date = date
        gulp.quantity = quantity
        
        entry?.gulps = [gulp]
        
        do {
            try context.save()
            
        } catch let saveErr {
            print("Failed to save entry:", saveErr)
        }
    }

    
    func entryForDate(_ date: Date) -> Entry? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        var result = [Entry]()
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute],from: dateFrom)
        components.day! += 1
        let dateTo = calendar.date(from: components)! // eg. 2016-10-11 00:00:00
        // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time
        
        // Set predicate as date being today's date
        let datePredicate = NSPredicate(format: "(%@ <= date) AND (date < %@)", argumentArray: [dateFrom, dateTo])
        request.predicate = datePredicate
        request.returnsObjectsAsFaults = false

        do {
            result = try context.fetch(request)
            for data in result {
                print(data.date as Any )
                print(data.percentage as Any )
                print(data.gulps?.allObjects as Any )
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return result.first
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
    
    /**
     Returns the current entry if available, or creates a new one instead
     - returns: Entry
     */
    func currentEntry() -> Entry {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if let entry = entryForDate(Date()) {
            return entry
        } else {
            let newEntry = Entry(context: context)
            do {
                try context.save()
            } catch let saveErr {
                print("Failed to save company:", saveErr)
            }
            return newEntry
        }
    }    
    
    
    func removeLastGulp() {
//        HealthKitHelper.sharedHelper.removeLastSample()
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let entry = currentEntry()
        if let gulps = entry.gulps {
            let lastGulp = gulps.allObjects[gulps.count - 1] as! Gulp
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
