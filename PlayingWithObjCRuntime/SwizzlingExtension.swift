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
		swizzleMethod(withName: "getBgColor", withMethod: "getNewBgColor")
	}

	private static func swizzleText() {
		swizzleMethod(withName: "getText", withMethod: "getNewText")
	}

	private static func swizzleMethod(withName original: String, withMethod swizzled: String) {
		let originalSelector = Selector(original)
		let swizzledSelector = Selector(swizzled)

		guard let originalMethod = class_getInstanceMethod(self, originalSelector) else { return }
		guard let swizzledMethod = class_getInstanceMethod(self, swizzledSelector) else { return }

		let didAddMethod = class_addMethod(
			self,
			originalSelector,
			method_getImplementation(swizzledMethod),
			method_getTypeEncoding(swizzledMethod)
		)

		if didAddMethod {
			class_replaceMethod(
				self,
				swizzledSelector,
				method_getImplementation(originalMethod),
				method_getTypeEncoding(originalMethod)
			)
		} else {
			method_exchangeImplementations(originalMethod, swizzledMethod)
		}
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

