//
//  CustomUtil.swift
//  Robo
//
//  Created by Prabhakar Annavi on 26/03/18.
//  Copyright © 2018 Prabhakar Annavi. All rights reserved.
//

import Foundation
import UIKit

class CustomUtil {

    var navLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 40))


    func navBarWithImage(img: UIImage, vc: UIViewController) -> UIView {

        if let nc = vc.navigationController {

            let navBar = nc.navigationBar

            let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: navBar.frame.height, height: navBar.frame.height))
            titleImageView.center.x = navBar.center.x
            titleImageView.image = img

            navBar.addSubview(titleImageView)

            return titleImageView
        }
        return UIView()
    }

    func navTitle(text: String,vc: UIViewController) {

            if let nc = vc.navigationController {
                let navBar = nc.navigationBar
                navLabel.center.x  = navBar.center.x
                navLabel.center.y = navBar.center.y - navBar.frame.minY
                print("NavBARFrame", navBar.frame)
                navLabel.font = UIFont.systemFont(ofSize: 14)
                navLabel.text = text
                navLabel.textAlignment = .center
                navLabel.textColor = UIColor.darkText
                navBar.addSubview(navLabel)
            }

    }

    func changeNavTitleColor(vc: UIViewController, color: UIColor) {
        if var textAttributes = vc.navigationController?.navigationBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = color
            vc.navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
    }

    func customNavBar(vc: UIViewController) -> UIView {
        if let navBar = vc.navigationController?.navigationBar {
            let navView = UIView()
            navView.frame = CGRect(x: 0, y: 0, width: navBar.frame.width, height: navBar.frame.height)
            print("navBarFrame", navBar.frame)
            navView.backgroundColor = .blue

            navBar.addSubview(navView)
            return navView
        }
        return UIView()
    }

    func toast(title: String, message: String, timeToDisappear: Int, VC: UIViewController, animated: Bool, animCompletion: (() -> Void)? ) {


        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)

        VC.present(alert, animated: animated, completion: nil)

        let when = DispatchTime.now() + DispatchTimeInterval.seconds(timeToDisappear)

        DispatchQueue.main.asyncAfter(deadline: when) {

            alert.dismiss(animated: animated, completion: animCompletion)
        }
    }

    func showCustomToast(in vc: UIViewController, message : String) {


        let toastLabel = UILabel()
        toastLabel.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 50, width: 330, height: 40)
        toastLabel.text = message
        toastLabel.numberOfLines = 0

        //To resize and center the label with desired width
        toastLabel.sizeThatFits(CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        print("ToastFrameAfterSizeToFit-->", toastLabel.frame)

        toastLabel.center.x = UIScreen.main.bounds.width/2
        toastLabel.backgroundColor = UIColor.darkGray
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)

        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 5
        toastLabel.clipsToBounds  =  true

        vc.view.addSubview(toastLabel)

        UIView.animate(withDuration: 1.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseInOut, animations: {

            toastLabel.frame.origin.y -= 50

        }) { (isCompleted) in
            _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in

                toastLabel.alpha = 0.0

                toastLabel.removeFromSuperview()

                timer.invalidate()
            })
        }

    }

}
