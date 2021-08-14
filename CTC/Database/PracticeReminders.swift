
import Foundation
import CoreData
import UIKit

class PracticeReminder {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var reminder = [Reminder]()
    let weekDict = ["Sunday" : 1, "Monday" : 2, "Tuesday" : 3, "Wednesday" : 4, "thursday" : 5, "Friday" : 6, "Saturday" : 7]
    
    func AddReminder(uid: String,daysLabel : String,hour: Int16,minute: Int16,practiceName: String,identifier:String) {
        let reminder = Reminder(context: self.context)
        reminder.uid = uid
        reminder.day = daysLabel
        reminder.hour = hour
        reminder.minute = minute
        reminder.practiceName = practiceName
        reminder.identifier = identifier
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        
        
        
    }
    func UpdateReminder(uid: String,daysLabel : String,hour: Int16,minute: Int16,practiceName: String,identifier:String) {
        let reminder = loadReminderbyPracticeName(uid: uid)
        for data in reminder {
            if data.identifier == identifier{
                data.day = daysLabel
                data.hour = hour
                data.minute = minute
                data.practiceName = practiceName
                data.identifier = identifier
            }
            
        }
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        
        
        
    }
    func RemoveReminder(uid:String){
        reminder = loadReminderbyPracticeName(uid: uid)
        for practices in reminder{
            if practices.uid == uid{
                deleteNotification(remind: practices)
            }
            
        }
        
    }
    func RemoveOneReminder(remind:Reminder)  {
        
        if remind.day == "Weekdays" {
            for i in 2...6 {
                NotificationManager.instance.cancelNotification(identifier: remind.practiceName!+"\(i)"+remind.day!+"\(remind.hour)"+"\(remind.minute)")
                
            }
        }else if remind.day == "Everyday"{
            for i in 1...7 {
               
                NotificationManager.instance.cancelNotification(identifier: remind.practiceName!+"\(i)"+remind.day!+"\(remind.hour)"+"\(remind.minute)")
                
            }
        }else {
            for weekday in weekDict {
                if weekday.key == remind.day{
                    NotificationManager.instance.cancelNotification(identifier: (PopUpReminder.selectPractice?.practice)!+"\(weekday.value)"+"\(remind.hour)"+"\(remind.minute)")
                    
                }
            }
        }
        
    }
    func deleteNotification(remind : Reminder) {
        if remind.day == "Weekdays" {
            for i in 2...6 {
                NotificationManager.instance.cancelNotification(identifier: remind.practiceName!+"\(i)"+remind.day!+"\(remind.hour)"+"\(remind.minute)")
                
            }
        }else if remind.day == "Everyday"{
            for i in 1...7 {
                NotificationManager.instance.cancelNotification(identifier: remind.practiceName!+"\(i)"+remind.day!+"\(remind.hour)"+"\(remind.minute)")
                
            }
        }else {
            for weekday in weekDict {
                if weekday.key == remind.day{
                    NotificationManager.instance.cancelNotification(identifier: (PopUpReminder.selectPractice?.practice)!+"\(weekday.value)"+"\(remind.hour)"+"\(remind.minute)")
                    
                }
            }
        }
        
    }
    func loadReminderbyPracticeName(uid: String) -> [Reminder]{
        
        let request = NSFetchRequest<Reminder>(entityName: "Reminder")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "uid = %@", argumentArray: [uid])
        do {
            reminder = try context.fetch(request)
        } catch let err {
            print(err)
        }
        
        return reminder
    }

    func loadReminderbyPracticeNameonly(uid: String) -> Reminder?{
        var rem  : Reminder?
        let request = NSFetchRequest<Reminder>(entityName: "Reminder")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "uid = %@", argumentArray: [uid])
        do {
            print(uid)
            reminder = try context.fetch(request)
            for data in reminder {
                if data.uid == uid {
                    rem = data
                }
            }
            return rem ?? nil
        
        } catch let err {
            print(err)
        }
        return nil
       
    }
    func checkIdentifier(identifier: String) -> Bool {
        let request = NSFetchRequest<Reminder>(entityName: "Reminder")
        request.predicate = NSPredicate(format: "identifier = %@", argumentArray: [identifier])
        do {
            reminder = try context.fetch(request)
            print("hello \(reminder)")
        } catch let err {
            print(err)
        }
        if reminder.isEmpty {
            return true
        }else{
            return false
        }
    }
    func deleteReminder(reminder: Reminder) {
        
        context.delete(reminder)
        
        do {
            try context.save()
        } catch let err {
            print(err)
            
        }
    }
    
}
