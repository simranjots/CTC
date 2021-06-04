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
        let weeklyPracticedData = getPracticeWeeklyData()!
        
        
        
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
        //        var finalDataArray = [ [String: [ [String:String?] ] ] ]()
        finalDateArray = [String: [ [String:String?] ] ]()
        //        var dateArray = [NSDate]()
        
        let weeklyPracticedData = getPracticeWeeklyData()!
        
        for practice in practices!{
            
            
            let practiceData = getPracticebyName(practice: practice)
            let practiceDateArray = (practice.startedday! as Date).getDates(date: Date())
            var bufferData = [[String: String?]]()
            var bufferWeeklyData = [[String: String?]]()
            
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

    //MARK: Practice Data class
    //-------------------------------------------------------------------------------------------------------------------------------
    
    
    
    
    
    func addPracticeData(note: String, practised: Bool, practice: Practice, date: Date) -> Int {
        let resultFlag = maintainTrackingDay(date: date, flag: practised, practice: practice)
        
        print(resultFlag ? "Trakcing Day Maintened Successfully" : "Error in Maintenance Tracking Days")
        var practicePracticedDays = practice.practiseddays
        //        var date5 = DateComponents(calendar: .current, year: 2019, month: 3, day: 4).date!
        //        date5 = Date().dateFormate()!
        
        var trackingDays = (getTrackingDay(practice: practice, date: date)) ?? 0
        
        //        var trackingDay: Int32!
        
        let lasrDayData = getPracticeDataByDateAndName(date: date.dateFormate()!, practiceName: practice.practice!)
        
        //        print("-------------------------last day data --------------------------------------------")
        //        print(Date().dateFormate())
        //        print(practice.practice)
        //        print(lasrDayData)
        
        if lasrDayData != nil{
            
            trackingDays = lasrDayData!.tracking_days
            
            
            if (practised == true && lasrDayData?.practised == false){
                trackingDays = (trackingDays) + 1
                practicePracticedDays = practicePracticedDays + 1
            }else if (practised == false && lasrDayData?.practised == true){
                trackingDays = trackingDays - 1
                practicePracticedDays = practicePracticedDays - 1
            }
            lasrDayData!.practised = practised
            lasrDayData?.note = note
            lasrDayData!.practiceDataToPractice = practice
            lasrDayData!.tracking_days = (trackingDays)
            userPractices.updatePracticedDay(noOfDays: Int(practicePracticedDays), practiceName: practice.practice!, user: practice.user!)
            do{
                try context?.save()
            }
            catch let err{
                print(err)
                return 1
            }
            //            }
        }
        else{
            
            let newPracticesData = NSEntityDescription.insertNewObject(forEntityName: "PracticeData", into: context!) as! PracticeData
            
            //            newPracticesData.date = Date().dateFormate()! as NSDate
            //            newPracticesData.date = Date().dateFormate()! as NSDate
            newPracticesData.date = date.dateFormate()! as NSDate
            newPracticesData.note = note
            newPracticesData.practised = practised
            newPracticesData.practiceDataToPractice = practice
            
            if(practised == true)
            {
                trackingDays = trackingDays + 1
                practicePracticedDays = practicePracticedDays + 1
            }
            newPracticesData.tracking_days = trackingDays
            if (practised){
                userPractices.updatePracticedDay(noOfDays: Int(practicePracticedDays), practiceName: practice.practice!, user: practice.user!)
            }
            
            do{
                try context?.save()
                return 0
            }
            catch let err{
                print(err)
                return 1
            }
            
        }
        
        return 0
        
    }
    
    func addPracticeData(practised: Bool, practice: Practice, date: Date) -> Int {
        let resultFlag = maintainTrackingDay(date: date, flag: practised, practice: practice)
        var practicePracticedDays = practice.practiseddays
        
        print(resultFlag ? "Trakcing Day Maintened Successfully" : "Error in Maintenance Tracking Days")
        
        var trackingDays = (getTrackingDay(practice: practice, date: date) ?? 0)
        
        let lasrDayData = getPracticeDataByDateAndName(date: date.dateFormate()!, practiceName: practice.practice!)
        //        print("-------------------------last day data --------------------------------------------")
        //        print(Date().dateFormate())
        //        print(practice.practice)
        //        print(lasrDayData)
        
        if lasrDayData != nil{
            
            trackingDays = lasrDayData!.tracking_days
            
            
            if (practised && lasrDayData?.practised == false){
                trackingDays += 1
                practicePracticedDays = practicePracticedDays + 1
            }else if (practised == false && lasrDayData?.practised == true){
                trackingDays -= 1
                practicePracticedDays = practicePracticedDays - 1
            }
            lasrDayData!.practised = practised
            lasrDayData!.practiceDataToPractice = practice
            lasrDayData!.tracking_days = Int32(trackingDays)
            //                updatePracticedDay(noOfDays: Int(trackingDays), practiceName: practice.practice!, user: practice.user!)
            do{
                try context?.save()
            }
            catch let err{
                print(err)
                return 1
            }
            //            }
        }
        else{
            
            let newPracticesData = NSEntityDescription.insertNewObject(forEntityName: "PracticeData", into: context!) as! PracticeData
            
            //            newPracticesData.date = Date().dateFormate()! as NSDate
            newPracticesData.date = date.dateFormate()! as NSDate
            newPracticesData.practised = practised
            newPracticesData.practiceDataToPractice = practice
            
            if(practised == true){
                //                  updatePracticedDay(noOfDays: Int(finalTrackingDay!), practiceName: practice.practice!, user: practice.user!)
                trackingDays = trackingDays + 1
                practicePracticedDays = practicePracticedDays + 1
            }
            
            newPracticesData.tracking_days = trackingDays
            if (practised){
                
            }
            
            do{
                try context?.save()
                
            }
            catch let err{
                print(err)
                return 1
            }
            
        }
        let finalTrackingDay = getTrackingDay(practice: practice)
        userPractices.updatePracticedDay(noOfDays: Int(practicePracticedDays), practiceName: practice.practice!, user: practice.user!)
        
        
        
        
        return 0
        
    }
    
    func getTrackingDay(practice: Practice,date: Date) -> Int32? {
        
        let startingDate = practice.startedday
        //        lastDate = DateComponents(calendar: .current, year: 2019, month: 3, day: 3).date!
        var dateArray = (startingDate! as Date).getDates(date: date)
        dateArray =  dateArray.sorted(by: >)
        for eachDate in dateArray{
            let lastDayData = getPracticeDataByDateAndName(date: eachDate.dateFormate()!, practiceName: practice.practice!)
            if(lastDayData != nil){
                return (lastDayData?.tracking_days)
            }
        }
        return 0
    }
    func getTrackingDay(practice: Practice) -> Int32? {
        
        let startingDate = practice.startedday
        //        lastDate = DateComponents(calendar: .current, year: 2019, month: 3, day: 3).date!
        var dateArray = (startingDate! as Date).getDates(date: Date())
        dateArray =  dateArray.sorted(by: >)
        for eachDate in dateArray{
            let lastDayData = getPracticeDataByDateAndName(date: eachDate.dateFormate()!, practiceName: practice.practice!)
            if(lastDayData != nil){
                return (lastDayData?.tracking_days)
            }
        }
        return 0
    }
    
    func getPracticeDataByDateAndName(date: Date, practiceName: String) -> PracticeData? {
        
        var lastDayData : PracticeData!
        
        let dataArray = getPracticeDataByDate(date: date)
        //        print(date)
        //        print(dataArray)
        if(dataArray != nil){
            for data in dataArray!{
                
                if(data.practiceDataToPractice?.practice == practiceName){
                    
                    lastDayData = data
                    //                    print("------------ Last Day in func ----------------------")
                    //                    print(lastDayData)
                }
            }
        }
        return lastDayData
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
    
    func getPracticeData(user: User) -> [PracticeData]?{
        
        var arrayReturn: [PracticeData]?
        
        let fearchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PracticeData")
        fearchRequest.returnsObjectsAsFaults = false
        fearchRequest.predicate = NSPredicate(format: "practiceDataToPractice.user = %@", argumentArray: [user])
        
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
        //        featchRequest.predicate = NSPredicate(format: "practiceDataToPractice.practice = %@", argumentArray: [practice.practice])
        
        
        
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
    
    func updatePracticeData(practiceName: String, practiceDate: Date, note: String, practiced: Bool ) -> Int {
        
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "dd-MM-yyyy"
        //
        //        let date = formatter.date(from: practiceDate)!
        
        let updateData = getPracticeDataByDateAndName(date: practiceDate, practiceName: practiceName)
        
        var trackingDay = updateData?.tracking_days
        
        if (practiced && updateData?.practised == false){
            trackingDay = trackingDay! + 1
        }else if (practiced == false && updateData?.practised == true){
            trackingDay = trackingDay! - 1
        }
        updateData?.tracking_days = trackingDay!
        updateData?.note = note
        updateData?.practised = practiced
        
        
        do {
            try context?.save()
        } catch let err {
            print(err)
            return 1
        }
        print("User \(practiceName) on \(practiceDate) Updated. . .")
        return 0
        
    }
    
    
    func maintainPracticeDataWeekly(user: User){
        
        let practiceData = getPracticeData(user: user)
        let practice = userPractices.getPractices(user: user)
        print(practiceData!)
        let oldDate = oldestPracticeDataDate(practiceData: practiceData!)
        let dayOfWeek = Date().getDayOfWeek()
        var dateArray = oldDate.getDates(date: Date())
        dateArray =  dateArray.sorted(by: <)
        var finalEndDate : Date?
        
        
        
        if(dayOfWeek == 6){
            
            let noOfDays = Date().days(from: oldDate)
            let noOfWeeks = Float(noOfDays) / 7.0
            
            var dictTemp : [[String : String]] = []
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
                        
                        for pracData in practiceData! {
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
                                        let result = addPracticeWeeklyData(practiceName: pracName, totalNoOfDaysPracticed: totalNoOfDaysPractice, totalNoOfDays: totalNoOfDays, startDay: weekStartDate, endDate: weekEndDate)
                                        
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
                            
                            for pracData in practiceData!{
                                if(pracData.date! as Date == date && pracData.practiceDataToPractice! == prac){
                                    delPracArray?.append(pracData)
                                }
                            }
                            
                        }
                        
                    }
                    deletePracticeData(practicesData: delPracArray!)
                }
            }
            
            
            
            print("Final Data -------------------------------------")
            //            print(dictTemp)
            
        }
        
    }
    
    func deletePracticeData(practicesData: [PracticeData]!) {
        
        for delprac in practicesData{
            context?.delete(delprac)
        }
        
        do {
            try context?.save()
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
    
    
    //MARK: Practice Data class over
    //-------------------------------------------------------------------------------------------------------------------------------
    
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
    
    
    func getPracticeWeeklyData() -> [WeeklyData]? {
        
        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeeklyData")
        featchRequest.returnsObjectsAsFaults = false
        
        do {
            let dataArray = try (context?.fetch(featchRequest) as? [WeeklyData])!
            //            print("Get practice data-----------------------------")
            //            print(dataArray)
            return dataArray
            
        } catch let err {
            print(err)
        }
        
        return nil
        
    }
    
    func getPracticeWeeklyData(practiceName: String) -> [WeeklyData]? {
        
        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeeklyData")
        featchRequest.returnsObjectsAsFaults = false
        featchRequest.predicate = NSPredicate(format: "practice_name = %@", argumentArray: [practiceName])
        
        do {
            let dataArray = try (context?.fetch(featchRequest) as? [WeeklyData])!
            //            print("Get practice data-----------------------------")
            //            print(dataArray)
            return dataArray
            
        } catch let err {
            print(err)
        }
        
        return nil
        
    }
    
    
    //MAEK: Practice Weekly calss over
    //-------------------------------------------------------------------------------------------------------------------------------
    
    
    
    
}
