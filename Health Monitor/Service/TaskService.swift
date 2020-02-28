//
//  TaskService.swift
//  Health Monitor
//
//  Created by Prabhakar Annavi on 26/02/20.
//  Copyright © 2020 Prabhakar Annavi. All rights reserved.
//

import Foundation

protocol TaskServiceDelegate {
    func didStoreTasksToCoreData()
}

class TaskService {

    private let httpClient = HttpClient()

    var delegate: TaskServiceDelegate?

    func requestForTasks() {
        let url = "https://38rhabtq01.execute-api.ap-south-1.amazonaws.com/dev/schedule"
        httpClient.getRequest(url: url, headers: nil, parameters: nil, sucCompletionHandler: { [weak self](response) in
            //response pares
            print("ResponseFOUND__>")
            let taskStore = TaskStore()
            taskStore.setData(jsonObj: response)

            self?.delegate?.didStoreTasksToCoreData()
        }) { (error) in
            print("error", error)
        }


    }
}
