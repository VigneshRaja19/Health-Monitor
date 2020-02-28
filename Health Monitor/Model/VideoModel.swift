//
//  Video+CoreDataClass.swift
//  Health Monitor
//
//  Created by Prabhakar Annavi on 26/02/20.
//  Copyright © 2020 Prabhakar Annavi. All rights reserved.
//

import Foundation

public class Video: NSObject, NSCoding {

    var title: String
    var hlsUrl: String
    var thumbnail: String

    init(title: String, hlsUrl: String, thumbnail: String) {
        self.title = title
        self.hlsUrl = hlsUrl
        self.thumbnail = thumbnail
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(hlsUrl, forKey: "hlsUrl")
        aCoder.encode(thumbnail, forKey: "thumbnail")
    }

    public required init?(coder aDecoder: NSCoder) {
        
        title = aDecoder.decodeObject(forKey: "title") as? String ?? ""
        hlsUrl = aDecoder.decodeObject(forKey: "hlsUrl") as? String ?? ""
        thumbnail = aDecoder.decodeObject(forKey: "thumbnail") as? String ?? ""

        super.init()
    }

}
