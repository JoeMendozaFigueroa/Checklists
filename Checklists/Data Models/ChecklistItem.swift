//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Josue Mendoza on 8/27/21.
//
import UserNotifications
import Foundation

//This is the class for the Notification, for when a user wants to be notified about a certain checklist item
class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    override init() {
        super.init()
        itemID = DataModel.nextChecklistItemID()
    }
    
    deinit {
        removeNotification()
    }
    //This method allows you to schedule and receive a notification alert within the app.
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            //This constant is for the text inside the notification
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default
            
            //These constants layout the information for the date scheduler
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
    }
    //This method removes the notification after it either: reminds the user, checklist item gets deleted, or user de-selects the reminder switch
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
}
