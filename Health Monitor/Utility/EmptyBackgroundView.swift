//
//  EmptyBackgroundView.swift
//  Robo
//
//  Created by Prabhakar Annavi on 10/09/18.
//  Copyright © 2018 Prabhakar Annavi. All rights reserved.
//

import UIKit

///Use this to set as a background view when no data found.
class EmptyBackgroundView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    ///Use this whenever the tableView height is smaller than usual.
    init(frame: CGRect, emptyText: String) {
        super.init(frame: frame)

        let font = UIFont.boldSystemFont(ofSize: 18)

        let label = UILabel(frame: CGRect(x: 0, y: 70, width: UIScreen.main.bounds.width, height: 40))
        label.center.x = self.center.x
        label.text = emptyText
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.font = font
        label.tag = 10
        self.addSubview(label)
    }

    ///Use this for regular tableView height.
    init(viewFrame: CGRect, emptyText: String, font: UIFont, textColor: UIColor) {
        super.init(frame: viewFrame)
        self.setupLabel(emptyText: emptyText, font: font, textColor: textColor)
    }

    private func setupLabel(emptyText: String, font: UIFont, textColor: UIColor) {

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        label.center.x = self.center.x
        label.center.y = self.center.y + 30
        label.text = emptyText
        label.textColor = textColor
        label.textAlignment = .center
        label.font = font
        label.tag = 10
        self.addSubview(label)
        print("emptyTextBackgroundView", emptyText, self, label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
