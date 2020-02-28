//
//  Task+CoreDataClass.swift
//  Health Monitor
//
//  Created by Prabhakar Annavi on 26/02/20.
//  Copyright © 2020 Prabhakar Annavi. All rights reserved.
//

import Foundation
import CoreData


public class Task: NSManagedObject {

    @NSManaged public var taskCD: String
    @NSManaged public var type: String
    @NSManaged public var frequency: Int32
    @NSManaged public var duration: Int32
    @NSManaged public var taskStartedDate: Date

    //schedule list
    @NSManaged public var session: String
    @NSManaged public var foodContext: String
    @NSManaged public var completionStatuses: [Bool]  // array size is duration

    @NSManaged public var drug: Drug?
    @NSManaged public var video: Video?


    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {

        return NSFetchRequest<Task>(entityName: "Task")
    }

    static func getAllTasks() -> [Task]? {
        let persistenceManager = PersistenceManager.shared
        do {
            guard let tasks = try persistenceManager.context.fetch(Task.fetchRequest()) as? [Task] else { return nil }

            print("didgetAllTasks", tasks.count)
            return tasks
        } catch {
            let error = error as NSError
            print("error_getting_persistenceManager", error)
            return nil
        }
    }

    static func filter(tasks: [Task], by date: Date) -> [Task] {

        var filteredTasks = [Task]()

        for i in 0..<tasks.count {
            let t = tasks[i]

            let frequency = Int(t.frequency)
            let duration = Int(t.duration)
            let comp = Set<Calendar.Component>([.day])
            let diff = Calendar.current.dateComponents(comp, from: t.taskStartedDate, to: date).day ?? 0
            print("diff", diff, frequency, t.taskStartedDate.dayOfMonth, date, t.taskStartedDate)

            if diff == 0 {
                filteredTasks.append(t)
            } else if frequency == 1 && diff < duration {
                filteredTasks.append(t)
            } else if diff % frequency == 0 {
                let ti = diff / frequency
                if ti <= duration {
                    filteredTasks.append(t)
                }
            }
        }

//        print("filteredTasksByDate-->", filteredTasks.count, filteredTasks)

        return filteredTasks
    }

    static func filter(tasks: [Task], by session: FoodSession) -> [Task] {

        var filteredTasks = [Task]()

        for i in 0..<tasks.count {
            if tasks[i].session == session.rawValue {
                filteredTasks.append(tasks[i])
            }
        }

        return filteredTasks
    }


//    static func getCompletedTasks(from tasks: [Task]) -> [Task] {
//        var completedTasks = [Task]()
//
//        for i in 0..<tasks.count {
//            if tasks[i].isCompleted {
//                completedTasks.append(tasks[i])
//            }
//        }
//        return completedTasks
//    }


}
