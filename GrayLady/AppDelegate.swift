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

class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate{
    var window: UIWindow?
    let SNSPlatformApplicationArn = "arn:aws:sns:us-east-1:467509107760:app/APNS_SANDBOX/GrayLady2"
    var navi: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        navi = UINavigationController(rootViewController: HomeTVC())
        navi?.navigationBar.isHidden = true
        window?.rootViewController = navi
        if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
           print(notification)


        } else {
            let center = UNUserNotificationCenter.current()
            let action = UNNotificationAction(identifier: Constrant.identifier.reply, title: "reply")
            let category = UNNotificationCategory(identifier: Constrant.identifier.category, actions: [action], intentIdentifiers: [])
            center.delegate = self
            center.setNotificationCategories([category])
            center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
             showDelayedNotification()
        }

      




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


    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       
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


    func showDelayedNotification() {
        let content = NotificationContent(title: Constrant.appName, subTitle: "Sub title here", body: "and this is the body")
               let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

        guard  let imageData = NSData(contentsOf: URL(string: "http://images.contentful.com/clmzlcmno5rw/13b0LcayL60YOmukCGSk4O/8511756c395051ff6eeb52cfe97858ac/briefing_1-President_Trump.jpg")!) else { return }
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)

        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let fileURL = tmpSubFolderURL.appendingPathComponent("image.jpg")
            try imageData.write(to: fileURL, options: [])
            let imageAttachment = try UNNotificationAttachment.init(identifier: Constrant.identifier.request, url: fileURL, options: [:])
            content.attachments.append(imageAttachment)

        } catch let error {
            print("error \(error)")
        }





        let request = UNNotificationRequest(identifier: Constrant.identifier.request, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
             UNUserNotificationCenter.current().delegate = self

            if (error != nil){
                //handle here
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification.request.content.attachments)
        completionHandler( [.alert, .badge, .sound])

    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       let home =  navi?.topViewController as! HomeTVC
       home.pushDetailFirst()
        
    }


   
    
    
}

