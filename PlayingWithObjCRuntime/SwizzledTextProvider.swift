//
//  SwizzledTextProvider.swift
//  PlayingWithObjCRuntime
//
//  Created by Игорь Клюжев on 28.09.2022.
//

import Foundation

class TextProvider: SelfAware {
    static func awake() {
        swizzleText()
    }

    private static func swizzleText() {
        swizzleMethod(#selector(getText), withMethod: #selector(getNewText))
    }

    @objc
    dynamic func getText() -> String {
        return "Some text"
    }

    @objc
    private func getNewText() -> String {
        return "Swizzled some text"
    }
}
