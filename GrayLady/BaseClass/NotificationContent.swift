//
//  NotificationContent.swift
//  Gray Lady
//
//  Created by David on 2/23/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationContent: UNMutableNotificationContent {

    init(title: String, subTitle: String, body: String) {
        super.init()
        self.title = title
        self.subtitle = subTitle
        self.body = body
        self.sound = UNNotificationSound.default()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
