//
//  SwizzlingHelpers.swift
//  PlayingWithObjCRuntime
//
//  Created by Игорь Клюжев on 28.09.2022.
//

import Foundation

protocol SelfAware: AnyObject {
    static func awake()
}

extension SelfAware {
    static func swizzleMethod(_ originalSelector: Selector,
                              withMethod swizzledSelector: Selector) {
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

// MARK: Do NOT name classes and funcs like this!
class NothingToSeeHere {
    static func harmlessFunction() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass?>.allocate(capacity: typeCount)
        let safeTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(safeTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            (types[index] as? SelfAware.Type)?.awake()
        }
        types.deallocate()
    }
}
