//
//  CustomSegmentedControl.swift
//  Robo
//
//  Created by Prabhakar Annavi on 22/01/19.
//  Copyright © 2019 Prabhakar Annavi. All rights reserved.
//


import UIKit

@IBDesignable
class CustomSegmentedControl: UIControl {

    var buttons = [UIButton]()
    var selector: UIView!
    var selectedSegmentIndex = 0



    @IBInspectable var borderWidth: CGFloat = 0 {

        didSet {
            layer.borderWidth = borderWidth
        }
    }


    @IBInspectable var cornerRadius: CGFloat = 0 {

        didSet {
            layer.cornerRadius = cornerRadius
        }
    }


//    @IBInspectable var borderColor: UIColor = .clear {
//
//        didSet {
//            layer.borderColor = borderColor.cgColor
//        }
//    }

    @IBInspectable var commaSeperatedButtonTitles: String = "" {

        didSet {
            updateView()
        }
    }

    @IBInspectable var textColor: UIColor = .lightGray {

        didSet {
            updateView()
        }
    }


    @IBInspectable var selectorColor: UIColor = .darkGray {

        didSet {
            updateView()
        }
    }

    @IBInspectable var selectorTextColor: UIColor = .green {

        didSet {
            updateView()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    func updateView() {

        buttons.removeAll()
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }

        let buttonTitles = commaSeperatedButtonTitles.components(separatedBy: ",")

        for buttonTitle in buttonTitles {

            let button = UIButton.init(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
            //            button.setTitleColor(button.isSelected ? UIColor.gray : selectorTextColor, for: .normal)
        }

        buttons[selectedSegmentIndex].setTitleColor(selectorTextColor, for: .normal)
        buttons[selectedSegmentIndex].titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)

        let selectorWidth = frame.width / CGFloat(buttonTitles.count)

        let y =    (self.frame.maxY - self.frame.minY) - 3.0

        let  selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(selectedSegmentIndex)

        selector = UIView.init(frame: CGRect.init(x: selectorStartPosition, y: y, width: selectorWidth, height: 3.0))
        //selector.layer.cornerRadius = frame.height/2
        selector.backgroundColor = selectorColor
        addSubview(selector)

        // Create a StackView

        let stackView = UIStackView.init(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

        print("UpdateView__", selectedSegmentIndex)

    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {

        // Drawing code

        // layer.cornerRadius = frame.height/2

    }


    @objc func buttonTapped(button: UIButton) {

        print("buttonTapped__OUter", selectedSegmentIndex)

        for (buttonIndex,btn) in buttons.enumerated() {

            btn.setTitleColor(textColor, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)

            if btn == button {
                selectedSegmentIndex = buttonIndex

                print("buttonTapped", selectedSegmentIndex)

                let  selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(buttonIndex)

                UIView.animate(withDuration: 0.2, animations: {

                    self.selector.frame.origin.x = selectorStartPosition
                })

                btn.setTitleColor(selectorTextColor, for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            }
        }

        sendActions(for: .valueChanged)

    }


    func updateSegmentedControlSegs(index: Int) {

        for btn in buttons {
            btn.setTitleColor(textColor, for: .normal)
        }

        let  selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(index)

        UIView.animate(withDuration: 0.2, animations: {

            self.selector.frame.origin.x = selectorStartPosition
        })

        buttons[index].setTitleColor(selectorTextColor, for: .normal)

    }


}

