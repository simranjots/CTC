import Foundation
import CoreData
import UIKit

class PracticedHistory {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dbHelper = DatabaseHelper()
    var firebaseDataManager = FirebaseDataManager()
    let currentUser = CurrentUser()

    func addPracticeHistory(hid :String,practiceName: String, comDelFlag: Bool, date: Date, dss: Int, td: Int,userOb:User) -> Int {
        let newHistory =  PracticeHistory(context: self.context)
        newHistory.hid = hid
        newHistory.practice_name = practiceName
        newHistory.com_del_flag = comDelFlag
        newHistory.date = date as NSDate
        newHistory.dss = Int32(dss)
        newHistory.td = Int32(td)
        newHistory.user = userOb
        let result = currentUser.saveUser()
        if result == 0 {
            firebaseDataManager.addPracticeHistoryToFirebase(id: newHistory.hid!, practiceName: practiceName, comDelFlag: comDelFlag, date: date, dss: dss, td: td, user: userOb)
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
    
   
    func deletePracticeHistory(practice: PracticeHistory) {
        
        context.delete(practice)
        
    }
}
