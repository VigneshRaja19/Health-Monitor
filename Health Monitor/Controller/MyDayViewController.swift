//
//  ViewController.swift
//  Health Monitor
//
//  Created by Prabhakar Annavi on 25/02/20.
//  Copyright © 2020 Prabhakar Annavi. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import AVKit
import AVFoundation

class MyDayViewController: UIViewController {


    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sessionSegment: CustomSegmentedControl!

    var visibleDate = Date() {
        didSet {
            dateLabel.text = String(visibleDate.dayOfMonth)
            monthLabel.text = visibleDate.monthName
        }
    }

    var imageCache = NSCache<AnyObject, UIImage>()

    let httpClient = HttpClient()

    let taskService = TaskService()

    var tasks: [Task] = []

    var tasksByDate: [Task] = []

    var tasksBySession: [Task] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        visibleDate = Date()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false

        let segment = CustomSegmentedControl()
        segment.commaSeperatedButtonTitles = "Morning,Afternoon,Evening,Night"

        let completedTasknib = UINib(nibName: "CompletedTaskCell", bundle: nil)
        tableView.register(completedTasknib, forCellReuseIdentifier: "CompletedTaskCell")

        let vodTaskNib = UINib(nibName: "VODTaskCell", bundle: nil)
        tableView.register(vodTaskNib, forCellReuseIdentifier: "VODTaskCell")

        let suppTaskNib = UINib(nibName: "SUPPTaskCell", bundle: nil)
        tableView.register(suppTaskNib, forCellReuseIdentifier: "SUPPTaskCell")

    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.addCustomNavTitle(title: "My Day")

        fetchTasks()
    }


    func fetchTasks() {
        if let taskArr = Task.getAllTasks(), !taskArr.isEmpty {
            print("TasksFOUND")
            self.tasks = taskArr

            self.tasksByDate = Task.filter(tasks: self.tasks, by: visibleDate)

            self.tableView.reloadData()
        } else {

            print("TasksTOBEREQuested")
            taskService.delegate = self
            taskService.requestForTasks()
        }
    }

    override func viewDidAppear(_ animated: Bool) {

    }

    func playVideoFromVideoController(urlStr: String) {
        if let url = URL(string: urlStr) {

            let playerVideoController = AVPlayerViewController()
            let player = AVPlayer(url: url)
            playerVideoController.player = player
            playerVideoController.modalPresentationStyle = .overCurrentContext
            playerVideoController.modalTransitionStyle = .crossDissolve
            self.present(playerVideoController, animated: true) {
                player.play()
            }
        }
    }

    func getDifferenceOfDates(date1: Date, date2: Date) -> Int {
        let comp = Set<Calendar.Component>([.day, .minute])
        let comp_result = Calendar.current.dateComponents(comp, from: date1, to: date2)
        let diff = comp_result.day ?? 0
        return diff
    }

    @IBAction func rightBtnAction(_ sender: Any) {

        if let d = Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: visibleDate) {

            visibleDate = d
            fetchTasks()
        }
    }

    @IBAction func leftBtnAction(_ sender: Any) {

        let calendar = Calendar.current
        if calendar.isDateInToday(visibleDate) {
            return
        }

        if let d = calendar.date(byAdding: Calendar.Component.day, value: -1, to: visibleDate) {

            visibleDate = d
            fetchTasks()
        }
    }

    @IBAction func sessionSegmentAction(_ sender: Any) {

        if !tasksBySession.isEmpty {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        tableView.reloadData()
    }

}

extension MyDayViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {

        print("numberOfSections", tasks.count)
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch sessionSegment.selectedSegmentIndex {
        case 0:
            tasksBySession = Task.filter(tasks: self.tasksByDate, by: .Morning)
            break
        case 1:
            tasksBySession = Task.filter(tasks: self.tasksByDate, by: .Afternoon)
            break
        case 2:
            tasksBySession = Task.filter(tasks: self.tasksByDate, by: .Evening)
            break
        case 3:
            tasksBySession = Task.filter(tasks: self.tasksByDate, by: .Night)
            break
        default:
            tasksBySession = Task.filter(tasks: self.tasksByDate, by: .Morning)
            break
        }

        if tasksBySession.isEmpty {
            let emptyBackgroundView = EmptyBackgroundView(frame: tableView.bounds, emptyText: "No tasks at this session")
            tableView.backgroundView = emptyBackgroundView
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
        }

        return tasksBySession.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let t = tasksBySession[indexPath.row]
        let duration = Int(t.duration)

        let diff = getDifferenceOfDates(date1: t.taskStartedDate, date2: visibleDate)

        let isToday = Calendar.current.isDateInToday(visibleDate)


//        let comp = Set<Calendar.Component>([.day, .minute])
//        let comp_result = Calendar.current.dateComponents(comp, from: t.taskStartedDate, to: visibleDate)
//        let diff = comp_result.day ?? 0
        print("dateComponents", diff, duration, t.completionStatuses.count)

        if diff < duration, t.completionStatuses[diff] {

            let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedTaskCell") as! CompletedTaskCell
            if let drug = t.drug {
                cell.leftImgView.image = UIImage.init(named: "supplements")
                cell.taskNameLabel.text = drug.brandNm
                cell.descLabel.text = String(drug.dosage.dose)+" "+drug.dosage.unit
                cell.rightImgView.image = UIImage(named: "iconCompleted")

            } else if let video = t.video {
                cell.leftImgView.image = UIImage.init(named: "vod")
                cell.taskNameLabel.text = video.title
                cell.descLabel.text = "Workplace Workouts" // data not provided in json
                cell.rightImgView.image = UIImage(named: "iconCompleted")
            }
            return cell
        } else if let drug = t.drug {

            let cell = tableView.dequeueReusableCell(withIdentifier: "SUPPTaskCell") as! SUPPTaskCell
            cell.medicineNameLabel.text = drug.brandNm
            cell.descLabel.text = String(drug.dosage.dose)+" "+drug.dosage.unit
            cell.leftImgView.image = UIImage.init(named: "supplements")
            cell.sessionLabel.text = t.foodContext
            cell.sessionImgView.image = UIImage.init(named: "npMeal1826996000000")

            //current date and visible date are same
            if isToday {
                cell.removeMaskFromTaskView()

                cell.takeAction = { [weak self] in
                    //change cell with completedCell
                    print("takeAction__cell", indexPath.row)
                    guard let self = self else { return }
                    t.completionStatuses[diff] = true
                    PersistenceManager.shared.saveContext()
                    self.tableView.reloadData()
                }

            } else {
                print("diffChange", diff)
                cell.addMaskToTaskView()
            }

            return cell

        } else if let video = t.video {

            let cell = tableView.dequeueReusableCell(withIdentifier: "VODTaskCell") as! VODTaskCell
            cell.taskLabel.text = video.title
            cell.durationLabel.text = String(t.duration)+" mins"
            cell.leftImgView.image = UIImage.init(named: "vod")

//            if diff > 0 {
//                cell.addMaskToTaskView()
//            }

            if let image = imageCache.object(forKey: video.thumbnail as AnyObject) {
                cell.thumbnailImgView.image = image
            } else {
                httpClient.downloadImage(fromURL: video.thumbnail) { [weak self](data) in
                    print("downloadImageData", data)
                    if let d = data, let image = UIImage(data: d) {
                        print("downloadImage", image)

                        DispatchQueue.main.async {
                            self?.imageCache.setObject(image, forKey: video.thumbnail as AnyObject)
                            cell.thumbnailImgView.image = image
                        }
                    }
                }
            }

            //current date and visible date are same
            if isToday {
                cell.removeMaskFromTaskView()

                cell.watchAction = { [weak self] in
                    //change cell with completedCell
                    print("takeAction__cell", indexPath.row)
                    guard let self = self else { return }

                    if let hlsUrl = t.video?.hlsUrl {
                        self.playVideoFromVideoController(urlStr: hlsUrl)
                    }

                    t.completionStatuses[diff] = true
                    PersistenceManager.shared.saveContext()
                    self.tableView.reloadData()
                }

            } else {
                print("diffChange", diff)
                cell.addMaskToTaskView()
            }

            return cell
        }

        return UITableViewCell()
    }

}
extension MyDayViewController: TaskServiceDelegate {

    func didStoreTasksToCoreData() {

        DispatchQueue.main.async {
            self.fetchTasks()
        }
    }
}
