import Foundation
import CoreData
import UIKit

class UserPracticesData {
    var tracking_days : Int32 = 0
    var practiceData : PracticeData!
    var arrayData : [PracticeData]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let userPractices = UserPractices()
    let dbHelper = DatabaseHelper()
    let currentUser = CurrentUser()
    var userObject: User!
    
    func practicedToday(toggleBtn: Bool, practiceObject: Practice, currentDate: Date,userObject: User!,note: String) -> Int {

        let resultFlag = dbHelper.maintainTrackingDay(date: currentDate, flag: toggleBtn, practice: practiceObject)
        var practicedDaysCount = practiceObject.practiseddays
        
        print(resultFlag ? "Trakcing Day Maintened Successfully" : "Error in Maintenance Tracking Days")
       
       practiceData =  getPracticeDataObj(practiceName: practiceObject.practice!, selectedDate: currentDate)
        
        
        
        tracking_days = (getTrackingDay(practice: practiceObject, date: currentDate) ?? 0)
        
        if  practiceData != nil{
            
            tracking_days = practiceData.tracking_days
            
            if (toggleBtn && practiceData.practised == false){
                tracking_days += 1
                practicedDaysCount += 1
            }else if (toggleBtn == false && practiceData.practised == true){
         
                tracking_days -= 1
                practicedDaysCount -= 1
            }
            practiceData.practised = toggleBtn
            practiceData.practiceDataToPractice = practiceObject
            practiceData.note = note
            practiceData.tracking_days = Int32(tracking_days)
        }
        else{
            
            let newPracticesData = PracticeData(context: self.context)
            
            newPracticesData.date = currentDate.dateFormate()! as NSDate
            newPracticesData.practised = toggleBtn
            newPracticesData.note = note
            newPracticesData.practiceDataToPractice = practiceObject
            
            if(toggleBtn == true){
                tracking_days += 1
                practicedDaysCount += 1
            }
            newPracticesData.tracking_days = tracking_days
        }
        userPractices.updatePracticedDay(noOfDays: Int(practicedDaysCount), practiceName: practiceObject.practice!, user: practiceObject.user!)
        let result = currentUser.saveUser()
        return result
         
    }
    

    func getPracticeDataObj(practiceName: String,selectedDate: Date) -> PracticeData? {
      
      arrayData = getPracticeDataByDate(date: selectedDate)
        if(arrayData != nil){
            for data in arrayData!{
                
                if(data.practiceDataToPractice?.practice == practiceName){
                    
                    practiceData = data
                }
            }
        }
        return practiceData
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
    
    func getPracticebyName(practice: Practice) -> [PracticeData]? {
        
        let request : NSFetchRequest<PracticeData> = PracticeData.fetchRequest()
        request.predicate = NSPredicate(format: "practiceDataToPractice = %@", argumentArray: [practice])
        
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
        for eachDate in dateArray{
            let lastDayData = getPracticeDataObj(practiceName: practice.practice!,selectedDate: eachDate.dateFormate()!)
            if(lastDayData != nil){
                return (lastDayData?.tracking_days)
            }
        }
        return 0
    }

    
    func updatePracticeData(practiceName: String, practiceDate: Date, note: String, practiced: Bool) -> Int {
    
        practiceData = getPracticeDataObj(practiceName: practiceName, selectedDate:practiceDate)
        
        tracking_days = practiceData.tracking_days
        
        if (practiced && practiceData.practised == false){
            tracking_days += 1
        }else if (practiced == false && practiceData?.practised == true){
            tracking_days -= 1
        }
        practiceData.tracking_days = tracking_days
        practiceData.note = note
        practiceData.practised = practiced
        
        let result = currentUser.saveUser()
        return result
        
    }
    
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
                                            print("Weekly Data Added With date \(weekStartDate)")
                                        }else{
                                            print("Error in Weekly Data adding")
                                        }
                                        
                                    }
                                    
                                    //                                    deletePracticeData(practiceData: pracData)
                                }
                                
                                
                            }
                            
                            
                            
                            
                        }
                        
                    }
                    
                    
                    
                }
                
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
