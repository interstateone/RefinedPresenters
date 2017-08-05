//
//  AppDelegate.swift
//  RefinedPresenters
//
//  Created by Brandon Evans on 2017-08-05.
//  Copyright © 2017 Brandon Evans. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var wireframe = MainWireframe()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let exampleView = window?.rootViewController as! ExampleViewController
        exampleView.delegate = ExamplePresenter(view: exampleView, wireframe: wireframe)
        return true
    }
}
