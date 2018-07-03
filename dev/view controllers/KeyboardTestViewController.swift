//
//  KeyboardTestViewController.swift
//  tyg
//
//  Created by Onur Ersel on 2018-07-03.
//  Copyright © 2018 Onur Ersel. All rights reserved.
//

import UIKit
import tyg

class KeyboardTestViewController: UIViewController {

    var labelShown: UILabel?
    var labelHeight: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.navigationItem.title = "Keyboard Test"

        let input = UITextField()
        self.view.addSubview(input)
        input.frame = CGRect(x: 0, y: 200, width: 300, height: 50)
        input.backgroundColor = .lightGray

        labelShown = UILabel()
        self.view.addSubview(labelShown!)
        labelShown!.tag = 92
        labelShown!.frame = CGRect(x: 0, y: 250, width: 300, height: 50)
        labelShown!.accessibilityIdentifier = "labelShown"

        labelHeight = UILabel()
        self.view.addSubview(labelHeight!)
        labelHeight!.tag = 93
        labelHeight!.frame = CGRect(x: 0, y: 300, width: 300, height: 50)
        labelHeight!.accessibilityIdentifier = "labelHeight"

        Tyg.Keyboard.changeState().observeNext { (info) in

            self.labelShown?.text = "\(info.isShown)"
            self.labelHeight?.text = "\(info.height)"

        }.dispose(in: bag)

        self.view.reactive.tapGesture().observeNext { (_) in
            input.resignFirstResponder()
        }.dispose(in: bag)
    }
}
