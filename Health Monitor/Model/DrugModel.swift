//
//  Drug+CoreDataClass.swift
//  Health Monitor
//
//  Created by Prabhakar Annavi on 26/02/20.
//  Copyright © 2020 Prabhakar Annavi. All rights reserved.
//

import Foundation

public class Drug: NSObject, NSCoding {

    var brandNm: String
    var genericNm: String
    var qty: Double
    var dosage: Dosage

    init(brandNm: String, genericNm: String, qty: Double, dosage: Dosage) {
        self.brandNm = brandNm
        self.genericNm = genericNm
        self.qty = qty
        self.dosage = dosage
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(brandNm, forKey: "brandNm")
        aCoder.encode(genericNm, forKey: "genericNm")
        aCoder.encode(qty, forKey: "qty")
        aCoder.encode(dosage, forKey: "dosage")
    }

    public required init?(coder aDecoder: NSCoder) {
        brandNm = aDecoder.decodeObject(forKey: "brandNm") as? String ?? ""
        genericNm = aDecoder.decodeObject(forKey: "genericNm") as? String ?? ""
        qty = aDecoder.decodeObject(forKey: "qty") as? Double ?? 0

        let dosageModel = Dosage(dose: 0, unit: "")
        dosage = aDecoder.decodeObject(forKey: "dosage") as? Dosage ?? dosageModel

        super.init()
    }
}


enum FoodSession: String {
    case Morning = "MORNING"
    case Afternoon = "AFTERNOON"
    case Evening = "EVENING"
    case Night = "NIGHT"
}
