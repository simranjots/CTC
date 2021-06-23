
import Foundation
import CoreData
import UIKit

class PracticeReminder {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var reminder = [Reminder]()
    let weekDict = ["Sunday" : 1, "Monday" : 2, "Tuesday" : 3, "Wednesday" : 4, "thursday" : 5, "Friday" : 6, "Saturday" : 7]
   
    func AddReminder(daysLabel : String,hour: Int16,minute: Int16,practiceName: String,identifier:String) {
        let reminder = Reminder(context: self.context)
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
    func UpdateReminder(daysLabel : String,hour: Int16,minute: Int16,practiceName: String,identifier:String) {
        let reminder = loadReminderbyPracticeName(practiceName: practiceName)
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
    func RemoveReminder(practiceName:String){
        reminder = loadReminderbyPracticeName(practiceName: practiceName)
        for practices in reminder{
            deleteReminder(reminder: practices)
            if practices.practiceName == practiceName{
                if practices.day == "Weekdays" {
                        NotificationManager.instance.cancelNotification(identifier: practiceName+"Weekdays"+"\(practices.hour)"+"\(practices.minute)")
                    
                }else if practices.day == "Everyday"{
                   
                        NotificationManager.instance.cancelNotification(identifier: practiceName+"Everyday"+"\(practices.hour)"+"\(practices.minute)")
                    
                }else {
                    for weekday in weekDict {
                        if weekday.key == practices.day {
                            NotificationManager.instance.cancelNotification(identifier: practiceName+"\(weekday.value)"+"\(practices.hour)"+"\(practices.minute)")
                            
                        }
                    }
                }
            }
        }
      
        }
    func loadReminderbyPracticeName(practiceName: String) -> [Reminder]{
        
        let request = NSFetchRequest<Reminder>(entityName: "Reminder")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "practiceName = %@", argumentArray: [practiceName])
        do {
            print(practiceName)
            reminder = try context.fetch(request)
            print(reminder)
        } catch let err {
            print(err)
        }
        
        return reminder
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
