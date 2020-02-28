//
//  TaskStore.swift
//  Health Monitor
//
//  Created by Prabhakar Annavi on 26/02/20.
//  Copyright © 2020 Prabhakar Annavi. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SwiftyJSON

class TaskStore: NSData {

    private(set) var tasks: [Task] = []

    var persistenceManager = PersistenceManager.shared

    var notifiedSessions = [String]()

    func setData(jsonObj: JSON) {

        let taskArr = jsonObj["tasks"].arrayValue

        for i in 0..<taskArr.count {
            let taskCd = taskArr[i]["taskCd"].stringValue
            let type = taskArr[i]["type"].stringValue
            let frequency = taskArr[i]["frequency"].intValue
            let duration = taskArr[i]["duration"].intValue
            let scheduleList = taskArr[i]["scheduleList"].arrayValue


            //Drug
            let drug = taskArr[i]["drug"]

            //Video
            let video = taskArr[i]["video"]

            //Schedule
            for j in 0..<scheduleList.count {



                let session = scheduleList[j]["session"].stringValue
                let foodContext = scheduleList[j]["foodContext"].stringValue


                var completionStatuses = [Bool]()

                let calendar = Calendar.current

                //TaskManagedObject

                let taskMO = Task(context: persistenceManager.context)
                taskMO.duration = Int32(duration)
                taskMO.foodContext = foodContext
                taskMO.frequency = Int32(frequency)
                taskMO.session = session
                taskMO.taskCD = taskCd
                taskMO.type = type

//                let date = calendar.date(byAdding: .minute, value: -10, to: Date()) ?? Date()
                let date = Date()
                taskMO.taskStartedDate = date  // json downloaded date

                if drug != JSON.null {

                    let brandNm = drug["brandNm"].stringValue
                    let genericNm = drug["genericNm"].stringValue
                    let qty = drug["qty"].intValue

                    let dosage = drug["dosage"]
                    let dose = dosage["dose"].intValue
                    let unit = dosage["unit"].stringValue

                    let dosageModel = Dosage(dose: dose, unit: unit)

                    let drugModel = Drug(brandNm: brandNm, genericNm: genericNm, qty: Double(qty), dosage: dosageModel)

                    //MO
                    taskMO.video = nil
                    taskMO.drug = drugModel
                    tasks.append(taskMO)

                }

                if video != JSON.null {
                    let title = video["title"].stringValue
                    let hlsUrl = video["hlsUrl"].stringValue
                    let thumbnail = video["thumbnail"].stringValue

                    let videoModel = Video(title: title, hlsUrl: hlsUrl, thumbnail: thumbnail)

                    //MO
                    taskMO.drug = nil
                    taskMO.video = videoModel
                    tasks.append(taskMO)

                }

                let df = DateFormatter()
                df.dateFormat = "HH:mm:ss"
                df.timeZone = TimeZone(secondsFromGMT: 0)
                df.dateFormat = "yyyy-MM-dd HH:mm:ss Z"

                for _ in 0..<duration {

                    completionStatuses.append(false)
                }


                if !notifiedSessions.contains(session) {

                    notifiedSessions.append(session)

                    for k in 0..<duration {

                        let curDate = Date()
                        let d = calendar.date(byAdding: .day, value: frequency*k, to: date) ?? curDate
                        var dateP = d.getDatePart()

                        if k == 0 {
                            dateP = date.getDatePart()
                        }

                        let morningSession = df.date(from: dateP+" 07:00:00 +0530")!
                        let afternoonSession = df.date(from: dateP+" 12:30:00 +0530")!
                        let eveningSession = df.date(from: dateP+" 16:30:00 +0530")!
                        let nightSession = df.date(from: dateP+" 20:00:00 +0530")!

                        if session == "MORNING" && curDate < morningSession {
                            if type == "SUPP", let drug = taskMO.drug {
                                self.addScheduler(at: morningSession, drug: drug, video: nil)
                            } else if type == "VOD", let video = taskMO.video {
                                self.addScheduler(at: morningSession, drug: nil, video: video)
                            }
                        } else if session == "AFTERNOON" && curDate < afternoonSession {
                            if type == "SUPP", let drug = taskMO.drug {
                                self.addScheduler(at: morningSession, drug: drug, video: nil)
                            } else if type == "VOD", let video = taskMO.video {
                                self.addScheduler(at: morningSession, drug: nil, video: video)
                            }
                        } else

                            if session == "EVENING" && curDate < eveningSession {
                            print("eveningSession", eveningSession)

                            if type == "SUPP", let drug = taskMO.drug {
                                self.addScheduler(at: eveningSession, drug: drug, video: nil)
                            } else if type == "VOD", let video = taskMO.video {
                                self.addScheduler(at: eveningSession, drug: nil, video: video)
                            }
                        }
                        else if session == "NIGHT" && curDate < nightSession {
                                print("NIGHTSession", nightSession)
                            if type == "SUPP", let drug = taskMO.drug {
                                self.addScheduler(at: nightSession, drug: drug, video: nil)
                            } else if type == "VOD", let video = taskMO.video {
                                self.addScheduler(at: nightSession, drug: nil, video: video)
                            }
                        }

                    }
                }

                taskMO.completionStatuses = completionStatuses

            }

        }
        persistenceManager.saveContext()
        print("afterSave")
    }

    private func addScheduler(at date: Date, drug: Drug?, video: Video?) {

        DispatchQueue.main.async {
//            print("addScheduler", date, drug, video)
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            if let drug = drug {
                appDelegate?.scheduleNotification(categoryIdentifier: String.randomString(length: 6), notificationTitle: "Time to take medicine", body: drug.brandNm+" - \(drug.dosage.dose) \(drug.dosage.unit)", date: date)
            } else if let video = video {
                appDelegate?.scheduleNotification(categoryIdentifier: String.randomString(length: 6), notificationTitle: "Time for workout", body: video.title, date: date)
            }
        }
    }


}
