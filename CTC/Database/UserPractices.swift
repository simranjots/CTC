import Foundation
import CoreData
import UIKit
class UserPractices{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let currentUser = CurrentUser()
    let remindPractices = PracticeReminder()
    var practices = [Practice]()
    var firebaseDataManager = FirebaseDataManager()
    func addPractices(practice: String, image_name: String,date: Date, user: User,value : String,encourage : String,remindswitch : Bool,goals : String) -> Int {
        
        let practices = getPractices(user: user)!
        var practiceNotExist = true
        
        for practiceData in practices{
            
            if(practiceData.practice == practice){
                
                practiceNotExist = false
            }
        }
        
        if(practiceNotExist){
            let newPractice = Practice(context: self.context)
            newPractice.values = value
            newPractice.practice = practice
            newPractice.image_name = image_name
            newPractice.startedday = date as NSDate
            newPractice.encourage = encourage
            newPractice.remindswitch = remindswitch
            newPractice.goals = goals
            newPractice.user = user
            let result = currentUser.saveUser()
            if result == 0 {
                firebaseDataManager.addPracticesToFirebase(practiceName: practice, image_name: image_name, date: date, user: user, value: value, encourage: encourage, remindswitch: remindswitch, goals: goals)
            }
            return result
        }else {
            print("Practice Exist")
            return 2
            
        }
        
    }
    
    func updatePractice(oldPractice: String, newPractice: String,image_name: String,date: Date, user: User,value : String,encourage : String,remindswitch : Bool,goals : String) -> Int {
        
        let practiceObject = getPractices(practiceName: oldPractice, user: user)
        practiceObject!.values = value
        practiceObject!.practice = newPractice
        practiceObject!.image_name = image_name
       // practiceObject.startedday = date as NSDate
        practiceObject!.encourage = encourage
        practiceObject!.remindswitch = remindswitch
        practiceObject!.goals = goals
        practiceObject!.user = user
        if oldPractice != newPractice {
            remindPractices.RemoveReminder(practiceName: oldPractice)
            #warning("Need to update Reminder")
        }
        if remindswitch == false {
        
            remindPractices.RemoveReminder(practiceName: oldPractice)
        }
        let result = currentUser.saveUser()
        if result == 0 {
            DispatchQueue.main.async {
                self.firebaseDataManager.updatePracticesInFirebase(oldPractice: oldPractice, newPractice: newPractice, image_name: image_name, user: user, value: value, encourage: encourage, remindswitch: remindswitch, goals: goals)
            }
            
        }
        return result
    }
    
    
    func getPractices(user: User) -> [Practice]? {
        
        let request : NSFetchRequest<Practice> = Practice.fetchRequest()
        request.predicate = NSPredicate(format: "user.email = %@ && is_deleted = %@ && is_completed = %@", argumentArray: [user.email!,false,false])
        request.sortDescriptors = [NSSortDescriptor(key: "startedday", ascending: true)]
        
        do {
            practices = try context.fetch(request)
            print(practices)
        } catch let err {
            print(err)
        }
        
        return practices
        
    }
    
    
    func getPractices(practiceName: String, user: User) -> Practice? {
        
        var practiceData : Practice?
        let request : NSFetchRequest<Practice> = Practice.fetchRequest()
        request.predicate = NSPredicate(format: "user.email = %@ && practice = %@ && is_deleted = %@ && is_completed = %@", argumentArray: [user.email!, practiceName, false, false])
        request.sortDescriptors = [NSSortDescriptor(key: "startedday", ascending: true)]
        
        do {
            practices = try context.fetch(request)
            for data in practices{
                practiceData = data
            }
        } catch let err {
            print(err)
        }
        
        return practiceData
        
    }
    
  
    
    
    func deletePractice(practice: Practice) {
        
        context.delete(practice)
        
    }
    
    func oldestPracticeDate(user: User) -> Date {
        
        let practicesData = getPractices(user: user)
        var oldestDate : Date = Date()
        for pracData in practicesData!{
            let pracDate = pracData.startedday! as Date
            if(pracDate < oldestDate){
                oldestDate = pracDate
            }
            
        }
        return oldestDate
    }
    
}
