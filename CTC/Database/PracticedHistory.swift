import Foundation
import CoreData
import UIKit

class PracticedHistory {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dbHelper = DatabaseHelper()
    var firebaseDataManager = FirebaseDataManager()
    let currentUser = CurrentUser()

    func addPracticeHistory(practiceName: String, comDelFlag: Bool, date: Date, dss: Int, td: Int,userOb:User) -> Int {
        let newHistory =  PracticeHistory(context: self.context)
        newHistory.practice_name = practiceName
        newHistory.com_del_flag = comDelFlag
        newHistory.date = date as NSDate
        newHistory.dss = Int32(dss)
        newHistory.td = Int32(td)
        newHistory.user = userOb
        let result = currentUser.saveUser()
        if result == 0 {
            firebaseDataManager.addPracticeHistoryToFirebase(practiceName: practiceName, comDelFlag: comDelFlag, date: date, dss: dss, td: td, user: userOb)
        }
        return result
    }
    
    func getPracticeHistory(userobject:User) -> [PracticeHistory]? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PracticeHistory")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "user = %@", argumentArray: [userobject])
        do {
            let dataArray = try (context.fetch(request) as? [PracticeHistory])!
            //            print("Get practice data-----------------------------")
            //            print(dataArray)
            return dataArray
            
        } catch let err {
            print(err)
        }
        
        return nil
        
    }
    
    func maintainTrackingDay(date: Date, flag: Bool, practice: Practice) -> Bool {
        
        var dateArray = date.getDates(date: Date())
        dateArray.remove(at: 0)
        
        for tempDate in dateArray{
            
            let pracData = dbHelper.getPracticeDataByDate(date: tempDate)
            if(flag == true){
                
                for pracobject in pracData!{
                    if(practice == pracobject.practiceDataToPractice){
                        pracobject.tracking_days = pracobject.tracking_days + 1
                    }
                }
                
            }else if (flag == false){
                
                for pracobject in pracData!{
                    if(practice == pracobject.practiceDataToPractice){
                        pracobject.tracking_days = pracobject.tracking_days - 1
                    }
                }
                
            }
            
        }
        
        do {
            try context.save()
        } catch let err {
            print(err)
            return false
        }
        print("Tracking Day Maintainance Completed")
        
        return true
    }
    func deletePracticeHistory(practice: PracticeHistory) {
        
        context.delete(practice)
        
    }
}
