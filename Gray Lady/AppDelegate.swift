//
//  AppDelegate.swift
//  Gray Lady
//
//  Created by David on 1/5/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = .whiteColor()
        window?.makeKeyAndVisible()
        let navi = UINavigationController(rootViewController: HomeTVC())
//        navi.hidesBarsOnSwipe = true
        window?.rootViewController = navi

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {       
    }


}

