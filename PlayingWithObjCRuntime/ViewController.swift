//
//  ViewController.swift
//  PlayingWithObjCRuntime
//
//  Created by Игорь Клюжев on 28.09.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = getBgColor()
        label.text = getText()
    }

    @objc
    dynamic func getBgColor() -> UIColor {
        return .red
    }

    @objc
    dynamic func getText() -> String {
        return "Text"
    }
}
