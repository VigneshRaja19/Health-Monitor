//
//  VODTaskCell.swift
//  Health Monitor
//
//  Created by Prabhakar Annavi on 25/02/20.
//  Copyright © 2020 Prabhakar Annavi. All rights reserved.
//

import UIKit

class VODTaskCell: UITableViewCell {

    @IBOutlet weak var leftImgView: UIImageView!
    @IBOutlet weak var thumbnailImgView: UIImageView!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var watchBtn: UIButton!
    @IBOutlet weak var videoView: UIView!

    var watchAction: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func addMaskToTaskView() {

        if self.videoView.mask == nil {

            let v = UIView(frame: self.videoView.bounds)
            v.backgroundColor = .lightGray
            v.alpha = 0.3

            self.videoView.mask = v

        }
    }

    func removeMaskFromTaskView() {
        self.videoView.mask = nil
    }

    @IBAction func watchBtnAction(_ sender: Any) {
        if watchAction != nil {
            watchAction!()
        }
    }


}
