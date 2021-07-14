import Foundation
import CoreData
import UIKit

class UserPracticesData {
    var uid : String = ""
    var tracking_days : Int32 = 0
    var streak : Int32 = 0
    var practiceData : PracticeData!
    var arrayData = [PracticeData]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let userPractices = UserPractices()
    let dbHelper = DatabaseHelper()
    let practiceHistory = PracticedHistory()
    let currentUser = CurrentUser()
    var firebaseDataManager = FirebaseDataManager()
    var userObject: User!
    var percentage : Int16 = 0
    var notesData : Notes!
    
    func practicedToday(toggleBtn: Bool, practiceObject: Practice, currentDate: Date,userObject: User!,note: String,save: String,check : Bool) -> Int {
     
        let resultFlag = practiceHistory.maintainTrackingDay(date: currentDate, flag: toggleBtn, practice: practiceObject)
        print(resultFlag ? "Trakcing Day Maintened Successfully" : "Error in Maintenance Tracking Days")
        
        practiceData =  getPracticeDataObj(practiceName: practiceObject.practice!)
        
        
        tracking_days = (getTrackingDay(practice: practiceObject, date: currentDate) ?? 0)
        streak =  (getStreak(practice: practiceObject))
        if  practiceData != nil{
            //notesData = practiceNotes.getPracticeNoteObj(noteuid: practiceData.noteuid!)
            tracking_days = practiceData.tracking_days
            
            if (toggleBtn && practiceData.practised == false){
                tracking_days += 1
                streak += 1
                
            }else if (toggleBtn == false && practiceData.practised == true){
                
                tracking_days -= 1
                
                streak -= 1
                
                
            }else if (toggleBtn == true && practiceData.practised == false){
                
                tracking_days += 1
                streak += 1
                
            }else if (toggleBtn  && practiceData.practised == true && save == ""){
               
                    tracking_days += 1
                    streak += 1
            }else if (toggleBtn  && practiceData.practised == true && save == "save" ){
               
                if (currentDate.dateFormate() != (practiceData.date! as Date).dateFormate()) {
                if check == true {
                    tracking_days += 1
                    streak += 1
                }
                }
            }
            
            if save == "save"{
                let Practices = PracticeData(context: self.context)
            
                if (currentDate.dateFormate() == (practiceData.date! as Date).dateFormate()) {
                          uid = practiceObject.uId!
                           practiceData.pNotes = note
                           practiceData.practised = toggleBtn
                           practiceData.date = currentDate.dateFormate()! as NSDate
                           practiceData.practiceDataToPractice = practiceObject
                           practiceData.tracking_days = Int32(tracking_days)
                           practiceData.streak = streak

                           }else{
                               Practices.pUid = practiceObject.uId!
                               Practices.pNotes = note
                               Practices.practised = toggleBtn
                               Practices.date = currentDate.dateFormate()! as NSDate
                               Practices.practiceDataToPractice = practiceObject
                               Practices.tracking_days = Int32(tracking_days)
                               Practices.streak = streak
                               uid = practiceData.pUid!
                           }

            }else{
                let Practices = PracticeData(context: self.context)
                if (currentDate.dateFormate() == (practiceData.date! as Date).dateFormate()) {
                          uid = practiceObject.uId!
                           practiceData.pNotes = note
                           practiceData.practised = toggleBtn
                           practiceData.date = currentDate.dateFormate()! as NSDate
                           practiceData.practiceDataToPractice = practiceObject
                           practiceData.tracking_days = Int32(tracking_days)
                           practiceData.streak = streak

                           }else{
                               Practices.pUid = practiceObject.uId!
                               Practices.pNotes = note
                               Practices.practised = toggleBtn
                               Practices.date = currentDate.dateFormate()! as NSDate
                               Practices.practiceDataToPractice = practiceObject
                               Practices.tracking_days = Int32(tracking_days)
                               Practices.streak = streak
                               uid = practiceData.pUid!
                           }

            }
            
            
        }
        else{
            let newPracticesData = PracticeData(context: self.context)
            newPracticesData.date = currentDate.dateFormate()! as NSDate
            newPracticesData.practised = toggleBtn
            newPracticesData.pUid = practiceObject.uId
            newPracticesData.practiceDataToPractice = practiceObject
            newPracticesData.pNotes = note
            
            if(toggleBtn == true){
                tracking_days += 1
                streak += 1
            }
            
            newPracticesData.streak = streak
            newPracticesData.tracking_days = tracking_days
            uid = practiceObject.uId!
        }
        let result = currentUser.saveUser()
        if result == 0 {
            firebaseDataManager.AddpracticedDataToFirebase(toggleStarBtn: toggleBtn, practiceName: practiceObject.practice!, PracticedDate: currentDate, user: userObject, note: note, streak: streak, trackingDays: tracking_days, uid: uid)
        }
        return result
    }
    func addPracticedData(toggleBtn: Bool, practiceObject: String, currentDate: Date,userObject: User!,uid: String,tracking_days: Int,streak:Int,note:String){
        let practice =  userPractices.getPractices(practiceName: practiceObject, user: userObject)
        let Practices = PracticeData(context: self.context)
        Practices.practised = toggleBtn
        Practices.date = currentDate.dateFormate()! as NSDate
        Practices.pUid = uid
        Practices.pNotes = note
        Practices.tracking_days = Int32(tracking_days)
        Practices.streak = Int32(streak)
        Practices.practiceDataToPractice = practice
        _ = currentUser.saveUser()
       
       
    }
    
    
    func getPracticeDataObj(practiceName: String) -> PracticeData? {
        
        arrayData = getPracticebyName(practice: practiceName)!
        for data in arrayData{
            if(data.practiceDataToPractice?.practice == practiceName){
                practiceData = arrayData.last
                return practiceData
            }
        }
        return nil
        
    }
    
    func getPracticeDataByDate(date: Date) -> [PracticeData]? {
        
        let request : NSFetchRequest<PracticeData> = PracticeData.fetchRequest()
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "date = %@", argumentArray: [date])
        
        do {
            let dateArray = try context.fetch(request)
            return dateArray
        } catch let err {
            print(err)
        }
        return nil
    }
    
    func getPracticebyName(practice: String) -> [PracticeData]? {
        
        let request : NSFetchRequest<PracticeData> = PracticeData.fetchRequest()
        request.predicate = NSPredicate(format: "practiceDataToPractice.practice = %@", argumentArray: [practice])
        
        do {
            let dataArray = try context.fetch(request)
            return dataArray
            
        } catch let err {
            print(err)
        }
        
        return nil
        
    }
    func getTrackingDay(practice: Practice,date: Date) -> Int32? {
        
        let startingDate = practice.startedday
        
        var dateArray = (startingDate! as Date).getDates(date: date)
        dateArray =  dateArray.sorted(by: >)
        for _ in dateArray{
            let lastDayData = getPracticeDataObj(practiceName: practice.practice!)
            if(lastDayData != nil){
                return (lastDayData?.tracking_days)
            }
        }
        return 0
    }
    func getStreak(practice: Practice) -> Int32 {
        let lastDayData = getPracticeDataObj(practiceName: practice.practice!)
        if(lastDayData != nil){
            let newDay = Date().days(from: lastDayData!.date! as Date )
            let Today =  Date().days(from: Date().originalFormate())
            let diff = newDay - Today
            print("diff \(diff)")
            if diff < 2 {
                return (lastDayData?.streak)!
            }
        }
        return 0
    }
    
    
//    func updatePracticeData(practiceName: String, practiceDate: Date, note: String, practiced: Bool) -> Int {
//        
//        practiceData = getPracticeDataObj(practiceName: practiceName)
//        
//        tracking_days = practiceData.tracking_days
//        
//        if (practiced && practiceData.practised == false){
//            tracking_days += 1
//        }else if (practiced == false && practiceData?.practised == true){
//            tracking_days -= 1
//        }
//        practiceData.tracking_days = tracking_days
//        practiceData.pNotes = note
//        practiceData.practised = practiced
//        
//        let result = currentUser.saveUser()
//        return result
//        
//    }
    
    func getPracticeData(user: User) -> [PracticeData]?{
        
        var arrayReturn: [PracticeData]?
        
        let fearchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PracticeData")
        fearchRequest.returnsObjectsAsFaults = false
        fearchRequest.predicate = NSPredicate(format: "practiceDataToPractice.user = %@", argumentArray: [user])
        
        do {
            let arrayData = try (context.fetch(fearchRequest)) as! [PracticeData]
            //            print(arrayData)
            arrayReturn = arrayData
            
        } catch let err {
            print(err)
        }
        
        
        
        return arrayReturn
    }
    
    func maintainPracticeDataWeekly(user: User){
        
        let arrayData = getPracticeData(user: user)
        let practice = userPractices.getPractices(user: user)
        let oldDate = oldestPracticeDataDate(practiceData: arrayData!)
        let dayOfWeek = Date().getDayOfWeek()
        var dateArray = oldDate.getDates(date: Date())
        dateArray =  dateArray.sorted(by: <)
        var finalEndDate : Date?
        
        
        
        if(dayOfWeek == 6){
            
            let noOfDays = Date().days(from: oldDate)
            let noOfWeeks = Float(noOfDays) / 7.0
            
            var totalNoOfDays : Int = 0
            var totalNoOfDaysPractice : Int = 0
            var weekStartDate : Date!
            var weekEndDate : Date!
            
            if(noOfWeeks >= 4.0){
                
                let restWeeks = noOfWeeks - 4.0
                let restDays = Int(restWeeks * 7.0)
                
                
                for prac in practice!{
                    weekStartDate = prac.startedday as Date?
                    let pracName = prac.practice!
                    totalNoOfDays = 0
                    totalNoOfDaysPractice = 0
                    
                    for i in 0...restDays{
                        
                        //                    for dateObject in dateArray{
                        let dateObject = dateArray[i]
                        
                        for pracData in arrayData! {
                            let pracDataName = pracData.practiceDataToPractice?.practice
                            
                            let pracDate = (pracData.date! as Date)
                            if(pracName == pracDataName){
                                
                                let dayNo = dateObject.getDayOfWeek()
                                if(dayNo == 1){
                                    weekStartDate = dateObject}
                                if(pracDate == dateObject){
                                    totalNoOfDays += 1
                                    
                                    if(pracData.practised){
                                        totalNoOfDaysPractice += 1
                                    }
                                    
                                    
                                    
                                    if(dayNo == 7){
                                        weekEndDate = dateObject
                                        finalEndDate = dateObject
                                        //                                        print("Date : \(pracData.date)")
                                        let result = dbHelper.addPracticeWeeklyData(practiceName: pracName, totalNoOfDaysPracticed: totalNoOfDaysPractice, totalNoOfDays: totalNoOfDays, startDay: weekStartDate, endDate: weekEndDate)
                                        
                                        totalNoOfDaysPractice = 0
                                        totalNoOfDays = 0
                                        
                                        
                                        if(result == 0 ){
                                            print("Weekly Data Added With date \(String(describing: weekStartDate))")
                                        }else{
                                            print("Error in Weekly Data adding")
                                        }
                                        
                                    }
                                    
                                    // deletePracticeData(practicesData: pracData)
                                    
                                }}}}}
                
                if(finalEndDate != nil){
                    
                    var delPracArray : [PracticeData]? = []
                    for prac in practice!{
                        
                        let deletedDateArray = (prac.startedday! as Date).getDates(date: finalEndDate!)
                        for date in deletedDateArray {
                            
                            for pracData in arrayData!{
                                if(pracData.date! as Date == date && pracData.practiceDataToPractice! == prac){
                                    delPracArray?.append(pracData)
                                }
                            }
                            
                        }
                        
                    }
                    deletePracticeData(practicesData: delPracArray!)
                }
            }
        }
        
    }
    
    func deletePracticeData(practicesData: [PracticeData]!) {
        
        for delprac in practicesData{
            context.delete(delprac)
        }
        
        do {
            try context.save()
        } catch let err {
            print(err)
            
        }
        
        
    }
    
    func oldestPracticeDataDate(practiceData : [PracticeData]) -> Date {
        
        let practicesDate = practiceData
        var oldestDate : Date = Date()
        for prac in practicesDate{
            let pracDate = prac.date! as Date
            if(pracDate < oldestDate){
                oldestDate = pracDate
            }
            
        }
        return oldestDate
    }
    
    
}
