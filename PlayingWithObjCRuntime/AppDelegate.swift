//
//  AppDelegate.swift
//  PlayingWithObjCRuntime
//
//  Created by Игорь Клюжев on 28.09.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        NothingToSeeHere.harmlessFunction() // Do NOT name classes and funcs like this!

        return true
    }
}

