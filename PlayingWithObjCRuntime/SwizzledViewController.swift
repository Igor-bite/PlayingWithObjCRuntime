//
//  BackgroundColorProvider.swift
//  PlayingWithObjCRuntime
//
//  Created by Игорь Клюжев on 28.09.2022.
//

import UIKit

// MARK: - Method, invoked on start of app to swizzle methods

extension ViewController: SelfAware {
    static func awake() {
        swizzleBgColor()
        swizzleText()
    }
}

// MARK: - Swizzling

extension ViewController {
    private static func swizzleBgColor() {
        swizzleMethod(#selector(getBgColor), withMethod: #selector(getNewBgColor))
    }

    private static func swizzleText() {
        swizzleMethod(#selector(getText), withMethod: #selector(getNewText))
    }
}

// MARK: - New methods implementations

extension ViewController {
    @objc
    func getNewBgColor() -> UIColor {
        return .green
    }

    @objc
    func getNewText() -> String {
        return "Swizzled Text"
    }
}
