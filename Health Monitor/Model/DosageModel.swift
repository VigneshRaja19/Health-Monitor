//
//  Dosage+CoreDataClass.swift
//  Health Monitor
//
//  Created by Prabhakar Annavi on 26/02/20.
//  Copyright © 2020 Prabhakar Annavi. All rights reserved.
//

import Foundation

public class Dosage: NSObject, NSCoding {

    var dose: Int
    var unit: String

    init(dose: Int, unit: String) {
        self.dose = dose
        self.unit = unit
        super.init()
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(dose, forKey: "dose")
        aCoder.encode(unit, forKey: "unit")
    }

    public required init?(coder aDecoder: NSCoder) {
        dose = aDecoder.decodeInteger(forKey: "dose")
        unit = aDecoder.decodeObject(forKey: "unit") as? String ?? ""
        super.init()
    }
}
