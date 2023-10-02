//
//  UserAttention.swift
//  GeofenceHopper
//
//  Created by Takano Masanori on 2023/09/29.
//

import Foundation
import UserNotifications

class Notification {
    
    static func doNotification(message: String) {
        let content = UNMutableNotificationContent()
        content.body = message
        content.interruptionLevel = .active
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
