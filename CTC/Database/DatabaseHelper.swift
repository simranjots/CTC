import Foundation
import CoreData
import UIKit



class DatabaseHelper{
    
    let context: NSManagedObjectContext?
    let userPractices = UserPractices()
    
    init() {
        
        context = (UIApplication.shared.delegate  as? AppDelegate)?.persistentContainer.viewContext
        
    }
    
    func calculatePercentage(noOfDays: Int, totalNoOfDays: Int) -> Int {
        
        return (noOfDays/totalNoOfDays) * 100
        
    }
    
    func getPracRecordTemp(user: User) -> [Date: [AnyObject]]? {
        
        let practices = userPractices.getPractices(user: user)
        //_ = getPracticeWeeklyData()!
        
        
        
        var finalData: [Date: [AnyObject]] = [:]
        
        for prac in practices!{
            let practiceData = getPracticebyName(practice: prac)
            let practiceDateArray = (prac.startedday! as Date).getDates(date: Date())
            for pracData in practiceData!{
                
                for dateObj in practiceDateArray{
                    
                    let pracDate = pracData.date! as Date
                    
                    if(dateObj == pracDate){
                        
                        if(finalData[dateObj] != nil){
                            
                            finalData[dateObj]?.append(pracData)
                            
                        }else{
                            
                            finalData[dateObj] = [pracData]
                            
                        }
                    }
                    
                }
                
            }
            
            
            let weeklyData = getPracticeWeeklyData(practiceName: prac.practice!)
            
            for weekData in weeklyData!{
                
                let weekDataDate = weekData.start_date! as Date
                for dateObj in practiceDateArray{
                    
                    if(dateObj == weekDataDate){
                        
                        if(finalData[dateObj] != nil){
                            
                            finalData[dateObj]?.append(weekData)
                            
                        }else{
                            
                            finalData[dateObj] = [weekData]
                            
                        }
                        
                        
                    }
                    
                }
                
                
                
            }
            
        }
        
        return finalData
        
    }
    
    func getPracticeRecords(user: User) ->  [String: [ [String: String?] ] ]? {
        
        getPracRecordTemp(user: user)
        
        var finalDateArray = [String:[[String:String?]]]()
        
        let practices = userPractices.getPractices(user: user)
        finalDateArray = [String: [ [String:String?] ] ]()
        for practice in practices!{
            
            
            let practiceData = getPracticebyName(practice: practice)
            let practiceDateArray = (practice.startedday! as Date).getDates(date: Date())
            var bufferData = [[String: String?]]()
            //var bufferWeeklyData = [[String: String?]]()
            
            for practiceDataObject in practiceData!{
                
                for dateObject in practiceDateArray{
                    
                    let dateOfObject = dateObject.dateFormateToString()
                    let dateOfData = (practiceDataObject.date! as Date).dateFormateToString()
                    
                    if(dateOfObject == dateOfData){
                        
                        if(finalDateArray[dateOfData!]?.count != nil){
                            bufferData = finalDateArray[dateOfData!]!
                            
                            bufferData.append( ["Practice" : practice.practice,"Note" : practiceDataObject.note, "TrackingDay" : String(practiceDataObject.tracking_days), "Practiced" : String(practiceDataObject.practised),
                                                "CellType" : "1"
                            ])
                            //                        print("buffer Array. . . . ")
                            //                        print(bufferData)
                            finalDateArray[dateOfData!] = (bufferData)
                            //                        print("final Array. . . . ")
                            //                        print(finalDateArray)
                        }else{
                            
                            bufferData = [( ["Practice" : practice.practice,"Note" : practiceDataObject.note, "TrackingDay" : String(describing: practiceDataObject.tracking_days), "Practiced" : String(practiceDataObject.practised),
                                             "CellType" : "1"
                            ])]
                            //                            print("buffer Array. . . . ")
                            //                            print(bufferData)
                            finalDateArray[dateOfData!] = (bufferData)
                            //                            print("final Array. . . . ")
                            //                            print(finalDateArray)
                            
                            
                        }
                    }
                    
                }
                
            }
        }
        
        print("from database--------------------------")
        //                        print(practiceBufferDict)
        for (key, val) in finalDateArray{
            
            print("Key = \(key)")
            for valu in val{
                
                print("\(valu)")
            }
            
        }
        return finalDateArray
        
    }


    
    func getPracticeDataByDate(date: Date) -> [PracticeData]?{
        
        var arrayReturn: [PracticeData]?
        
        let fearchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PracticeData")
        fearchRequest.returnsObjectsAsFaults = false
        fearchRequest.predicate = NSPredicate(format: "date = %@", argumentArray: [date])
        
        do {
            let arrayData = try (context?.fetch(fearchRequest)) as! [PracticeData]
            //            print(arrayData)
            arrayReturn = arrayData
        } catch let err {
            print(err)
        }
        
        return arrayReturn
    }
    

    
    func getPracticebyName(practice: Practice) -> [PracticeData]? {
        
        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PracticeData")
        featchRequest.predicate = NSPredicate(format: "practiceDataToPractice = %@", argumentArray: [practice])
 
        
        do {
            let dataArray = try (context?.fetch(featchRequest) as? [PracticeData])!
            //            print("Get practice data-----------------------------")
            //            print(dataArray)
            return dataArray
            
        } catch let err {
            print(err)
        }
        
        return nil
        
    }
    
    
    //MARK: Practice History class
    //-------------------------------------------------------------------------------------------------------------------------------
    
    func addPracticeHistory(practiceName: String, comDelFlag: Bool, date: Date, dss: Int, td: Int) -> Int {
        let newHistory = NSEntityDescription.insertNewObject(forEntityName: "PracticeHistory", into: context!) as! PracticeHistory
        
        newHistory.practice_name = practiceName
        newHistory.com_del_flag = comDelFlag
        newHistory.date = date as NSDate
        newHistory.dss = Int32(dss)
        newHistory.td = Int32(td)
        
        
        
        do {
            try context?.save()
        } catch let err {
            print(err)
            return 1
        }
        
        return 0
    }
    
    func getPracticeHistory() -> [PracticeHistory]? {
        
        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PracticeHistory")
        featchRequest.returnsObjectsAsFaults = false
        
        do {
            let dataArray = try (context?.fetch(featchRequest) as? [PracticeHistory])!
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
            
            let pracData = getPracticeDataByDate(date: tempDate)
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
            try context?.save()
        } catch let err {
            print(err)
            return false
        }
        print("Tracking Day Maintainance Completed")
        
        return true
    }
    
    //MAEK: Practice History calss over
    //-------------------------------------------------------------------------------------------------------------------------------
    
    
    //MAEK: Practice Weekly  calss
    //-------------------------------------------------------------------------------------------------------------------------------
    
    func addPracticeWeeklyData(practiceName: String, totalNoOfDaysPracticed: Int, totalNoOfDays: Int, startDay: Date, endDate: Date) -> Int {
        let newWeeklyData = NSEntityDescription.insertNewObject(forEntityName: "WeeklyData", into: context!) as! WeeklyData
        
        newWeeklyData.practice_name = practiceName
        newWeeklyData.no_of_days_practiced = Int32(totalNoOfDaysPracticed)
        newWeeklyData.total_no_of_days = Int32(totalNoOfDays)
        newWeeklyData.start_date = startDay as NSDate
        newWeeklyData.end_date = endDate as NSDate
        
        
        do {
            try context?.save()
        } catch let err {
            print(err)
            return 1
        }
        
        return 0
    }
    
//
//    func getPracticeWeeklyData() -> [WeeklyData]? {
//
//        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeeklyData")
//        featchRequest.returnsObjectsAsFaults = false
//
//        do {
//            let dataArray = try (context?.fetch(featchRequest) as? [WeeklyData])!
//            //            print("Get practice data-----------------------------")
//            //            print(dataArray)
//            return dataArray
//
//        } catch let err {
//            print(err)
//        }
//
//        return nil
//
//    }
//
    func getPracticeWeeklyData(practiceName: String) -> [WeeklyData]? {
        
        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeeklyData")
        featchRequest.returnsObjectsAsFaults = false
        featchRequest.predicate = NSPredicate(format: "practice_name = %@", argumentArray: [practiceName])
        
        do {
            let dataArray = try (context?.fetch(featchRequest) as? [WeeklyData])!
       
            return dataArray
            
        } catch let err {
            print(err)
        }
        
        return nil
        
    }
    
    
    //MAEK: Practice Weekly calss over
    //-------------------------------------------------------------------------------------------------------------------------------
    
    
    
    
}
