//
//  SUPPTaskCell.swift
//  Health Monitor
//
//  Created by Prabhakar Annavi on 25/02/20.
//  Copyright © 2020 Prabhakar Annavi. All rights reserved.
//

import UIKit

class SUPPTaskCell: UITableViewCell {

    @IBOutlet weak var leftImgView: UIImageView!
    @IBOutlet weak var takeBtn: UIButton!
    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var sessionImgView: UIImageView!
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var taskView: UIView!

    var takeAction: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func addMaskToTaskView() {

        if self.taskView.mask == nil {
            let v = UIView(frame: self.taskView.bounds)
            v.backgroundColor = .lightGray
            v.alpha = 0.3

            self.taskView.mask = v

        }
    }

    func removeMaskFromTaskView() {
        self.taskView.mask = nil
    }

    @IBAction func takeBtnAction(_ sender: Any) {
        if takeAction != nil {
            takeAction!()
            print("takeActionCalled")
        }
    }

}
