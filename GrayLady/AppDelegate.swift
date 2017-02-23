//
//  AppDelegate.swift
//  GrayLady
//
//  Created by David on 1/10/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import AWSSNS

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let SNSPlatformApplicationArn = "arn:aws:sns:us-east-1:467509107760:app/APNS_SANDBOX/GrayLady2"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        let navi = UINavigationController(rootViewController: HomeTVC())
        navi.navigationBar.isHidden = true
        window?.rootViewController = navi
      
        let center = UNUserNotificationCenter.current()
        let action = UNNotificationAction(identifier: Constrant.identifier.reply, title: "reply")
        let category = UNNotificationCategory(identifier: Constrant.identifier.category, actions: [action], intentIdentifiers: [])
        center.setNotificationCategories([category])
        center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        application.registerForRemoteNotifications()


        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})

        // Print it to console
        print("APNs device token: \(deviceTokenString)")

        UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken")

        // First create the AWS endpoint for the device
        let sns = AWSSNS.default()
        let request = AWSSNSCreatePlatformEndpointInput()
        request?.token = deviceTokenString
        request?.platformApplicationArn = SNSPlatformApplicationArn

        sns.createPlatformEndpoint(request!).continueWith(executor: AWSExecutor.mainThread(), block: { (task: AWSTask!) -> AnyObject! in
            if task.error != nil {
                print("Error: \(task.error)")
            } else {
                let createEndpointResponse : AWSSNSCreateEndpointResponse? = task.result
                print("endpointArn: \(createEndpointResponse?.endpointArn)")
                UserDefaults.standard.set(createEndpointResponse?.endpointArn, forKey: "endpointArn")
                // Then subscribe that endpoint to the master topic for notifications
                let subRequest = AWSSNSSubscribeInput()
                subRequest?.endpoint = createEndpointResponse?.endpointArn
                subRequest?.protocols = "application"
                subRequest?.topicArn = "arn:aws:sns:us-east-1:467509107760:outbound_push"
                sns.subscribe(subRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task: AWSTask!) -> AnyObject! in
                    if task.error != nil {
                        print("Error: \(task.error)")
                    } else {
                        let createSubResponse : AWSSNSSubscribeResponse? = task.result
                        print("subscription ARN: \(createSubResponse?.subscriptionArn)")
                    }

                    return nil
                })
            }
            return nil
        })


    }

    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    
}

