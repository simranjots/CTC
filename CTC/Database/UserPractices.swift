import Foundation
import CoreData
import UIKit
class UserPractices{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let currentUser = CurrentUser()
    var practices = [Practice]()
    func addPractices(practice: String, image_name: String,date: Date, user: User) -> Int {
        
        let practices = getPractices(user: user)!
        var practiceNotExist = true
        
        for practiceData in practices{
            
            if(practiceData.practice == practice){
                
                practiceNotExist = false
            }
        }
        
        if(practiceNotExist){
            let newPractice = Practice(context: self.context)
            newPractice.practice = practice
            newPractice.image_name = image_name
            newPractice.percentage = 0
            newPractice.startedday = date as NSDate
            newPractice.practiseddays = 0
            newPractice.user = user
            let result = currentUser.saveUser()
            return result
        }else {
            print("Practice Exist")
            return 2
            
        }
        
    }
    
    func updatePractice(oldPractice: String, newPractice: String,image_name: String,date: Date, user: User) -> Int {
        
        let practiceObject = getPractices(practiceName: oldPractice, user: user)
        
        practiceObject.practice = newPractice
        practiceObject.image_name = image_name
        practiceObject.startedday = date as NSDate
        practiceObject.user = user
        let result = currentUser.saveUser()
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
    
    
    func getPractices(practiceName: String, user: User) -> Practice {
        
        var practiceData : Practice!
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
    
    func updatePracticedDay(noOfDays: Int, practiceName: String, user: User){
        
        let practices = getPractices(practiceName: practiceName, user: user)
        
        practices.practiseddays = Int32(noOfDays)
        
        do {
            try context.save()
            print("Practice \(practiceName) Updated")
            
        } catch let err {
            print(err)
            
        }
        
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
