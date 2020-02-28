//
//  UIKit+Extension.swift
//  Health Monitor
//
//  Created by Prabhakar Annavi on 25/02/20.
//  Copyright © 2020 Prabhakar Annavi. All rights reserved.
//

import UIKit

extension UINavigationController {

    public func addCustomNavTitle(title: String) {

        let navBar = self.navigationBar
        let navLabel = UILabel(frame: CGRect(x: 30, y: 0, width: 250, height: 40))
        navLabel.center.y = navBar.center.y - navBar.frame.minY
        navLabel.font = UIFont.systemFont(ofSize: 25)
        navLabel.text = title
        navLabel.textAlignment = .left
        navLabel.textColor = UIColor.darkText
        navBar.addSubview(navLabel)
    }
}

extension String {
    static func randomString(length: Int) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
}

extension Date {

    ///Get Date from "yyyy-MM-dd HH:mm:ss Z" to "yyyy-MM-dd"
    func getDatePart() -> String {
        let df = DateFormatter()
        df.timeZone = TimeZone(secondsFromGMT: 0)
        df.dateFormat = "yyyy-MM-dd"
        let formattedDateStr = df.string(from: self)
        return formattedDateStr
    }

    /// Should enter dateString of format - "d-M-y"
    init(dateString: String) {

        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "d-MM-y hh:mm a"
        dateStringFormatter.timeZone = TimeZone(identifier: "UTC")
        let d = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval: 0, since: d)
    }

    ///Returns the full name of the month. Ex - January
    public var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let monthString = dateFormatter.string(from: self)
        return monthString
    }


    ///Returns the order of the month. Ex - 1
    public var month: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        let monthString = dateFormatter.string(from: self)
        let monthInt = Int(monthString) ?? 1
        return monthInt
    }

    ///Returns the order of the month. Ex - 1
    public var year: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "Y"
        let yearString = dateFormatter.string(from: self)
        let yearInt = Int(yearString) ?? 1
        return yearInt
    }


    ///Returns the 1 digit date. Ex - 9, 10
    public var dayOfMonth: Int {
        
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "d"
        let dateString = dateFormatter.string(from: self)
        let dateInt = Int(dateString) ?? 1
        return dateInt
    }

    ///Returns the full name of the day. Ex - Friday
    public var dayOfWeek: String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }

}
