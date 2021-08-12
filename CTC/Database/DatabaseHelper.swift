import Foundation
import CoreData
import UIKit



class DatabaseHelper{
    var monthInfo : WeeklyData!
    
    let userPractices = UserPractices()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
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
                            //"Note" : practiceDataObject.note
                            bufferData.append( ["Practice" : practice.practice, "TrackingDay" : String(practiceDataObject.tracking_days), "Practiced" : String(practiceDataObject.practised),
                                                "CellType" : "1"
                            ])
                            //                        print("buffer Array. . . . ")
                            //                        print(bufferData)
                            finalDateArray[dateOfData!] = (bufferData)
                            //                        print("final Array. . . . ")
                            //                        print(finalDateArray)
                        }else{
                            // ,"Note" : practiceDataObject.note
                            bufferData = [( ["Practice" : practice.practice, "TrackingDay" : String(describing: practiceDataObject.tracking_days), "Practiced" : String(practiceDataObject.practised),
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
            let arrayData = try (context.fetch(fearchRequest)) as! [PracticeData]
            arrayReturn = arrayData
        } catch let err {
            print(err)
        }
        
        return arrayReturn
    }
    
    
    
    func getPracticebyName(practice: Practice) -> [PracticeData]? {
        
        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PracticeData")
        featchRequest.predicate = NSPredicate(format: "practiceDataToPractice.uID = %@", argumentArray: [practice.uId])
        
        
        do {
            let dataArray = try (context.fetch(featchRequest) as? [PracticeData])!
            //            print("Get practice data-----------------------------")
            //            print(dataArray)
            return dataArray
            
        } catch let err {
            print(err)
        }
        
        return nil
        
    }
    
    
    
    
    //MAEK: Practice Weekly  calss
    //-------------------------------------------------------------------------------------------------------------------------------
    
    func addPracticeWeeklyData(practiceName: String, NoOfDaysPracticed: Int,id : String) -> Int {
        
        let newWeeklyData = WeeklyData(context: self.context)
        newWeeklyData.practice_name = practiceName
        newWeeklyData.no_of_days_practiced = Int32(NoOfDaysPracticed)
        newWeeklyData.month_id =  id
        
        do {
            try context.save()
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
        let request : NSFetchRequest<WeeklyData> = WeeklyData.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "practice_name = %@", argumentArray: [practiceName])
        
        do {
            let dataArray = try context.fetch(request)
            return dataArray
            
        } catch let err {
            print(err)
        }
        
        return nil
        
    }
    func getmonthlyData(practiceName: String) -> WeeklyData? {
        if let  monthdata = getPracticeWeeklyData(practiceName: practiceName){
            for data in monthdata{
                if(data.practice_name == practiceName){
                    monthInfo = monthdata.last
                    return monthInfo
                }
            }
            
        }
        return nil
    }
    func getMonthid(practiceName: String) -> Int32?{
        if let  monthdata = getmonthlyData(practiceName: practiceName){
            if monthdata.month_id == Date().getMonth(){
                return monthdata.no_of_days_practiced
            }else{
                return 0
            }
            
        }
        return 0
    }
    //MAEK: Practice Weekly calss over
    //-------------------------------------------------------------------------------------------------------------------------------
    
    
    
    
}
