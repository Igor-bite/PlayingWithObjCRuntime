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

class NothingToSeeHere {
    static func harmlessFunction() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass?>.allocate(capacity: typeCount)
        let safeTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(safeTypes, Int32(typeCount))
        for index in 0 ..< typeCount { (types[index] as? SelfAware.Type)?.awake() }
        types.deallocate()
    }
}
