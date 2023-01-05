//
//  NotificationScheduler.swift
//  Billminder
//
//  Created by Kvng Eko on 1/2/23.
//

import UserNotifications
import UIKit

class NotificationScheduler {
    
    func scheduleNotifications(bill: Bill) {
        guard let reminderDate = bill.reminderDate,
              let billIdentifier = bill.id else {return}
        let numberOfReminders = bill.billAmount / bill.minimumDue
        clearNotifications(bill: bill)
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Do not forget to make payment for \(bill.billName ?? "--missing bill name")"
        content.sound = .default
        content.categoryIdentifier = "BillNotification"
        let fireDateComponents =
        Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDateComponents, repeats: true)
        let currentDate = reminderDate
        var dateComponents = DateComponents()
        
        switch bill.repeatReminder {
        case "Every 2 Days":
            dateComponents.day = 2
            let twoDaysReminder = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        case "Every 7 days":
            dateComponents.day = 7
        case  "Every 14 days":
            dateComponents.day = 14
        case "Every 30 Days":
            dateComponents.day = 30
        default:
            break
        }
        
        let request = UNNotificationRequest(identifier: billIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("unable to add notification request, \(error.localizedDescription)")
            }
        }
    }
    
    func clearNotifications(bill: Bill) {
        guard let billIdentifier = bill.id else {return}
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [billIdentifier])
    }
}
