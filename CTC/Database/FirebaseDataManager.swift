import Foundation
import Firebase
import FirebaseFirestore
import UIKit
class FirebaseDataManager {
    
    let db = Firestore.firestore()
    typealias userAdded = (Bool,String,Data)->Void
    typealias practiceAdded = (Bool)->Void
    
    func addPracticesToFirebase(practiceName: String, image_name: String,date: Date, user: User,value : String,encourage : String,remindswitch : Bool,goals : String)  {
        let datas = ["id": practiceName,
                     "practiceName": practiceName,
                     "image_name": image_name,
                     "date": date,
                     "user": user.email!,
                     "value": value,
                     "encourage": encourage,
                     "remindswitch": remindswitch,
                     "goals": goals,
                     "practiced-days" : 0,
                     "is_completed": false,
                     "is_deleted": false
                     
        ] as [String : Any]
        db.collection("UsersData").document(user.uid!)
            .collection("Practices").document(practiceName)
            .setData(datas)
    }
    func updatePracticesInFirebase(oldPractice: String, newPractice: String,image_name: String, user: User,value : String,encourage : String,remindswitch : Bool,goals : String)  {
        let datas = ["id": oldPractice,
                     "practiceName": newPractice,
                     "image_name": image_name,
                     "user": user.email!,
                     "value": value,
                     "encourage": encourage,
                     "remindswitch": remindswitch,
                     "goals": goals
        ] as [String : Any]
        db.collection("UsersData").document(user.uid!)
            .collection("Practices").document(oldPractice)
            .setData(datas, merge: true)
    }
    
    func updateSinglePractices(valueName: String,value : Any,practiceName : String,uid : String){
        let practiceStringUpdate = db.collection("UsersData").document(uid)
            .collection("Practices").document(practiceName)
        practiceStringUpdate.updateData([
            "\(valueName)": value
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    func AddpracticedDataToFirebase(toggleStarBtn: Bool, practiceName: String, PracticedDate: Date,user: User,note: String,streak:Int32,trackingDays:Int32,percentage:Int){
        let datas = ["id": practiceName,
                     "practiceName": practiceName,
                     "PracticedDate": PracticedDate,
                     "user": user.email!,
                     "toggleStarBtn": toggleStarBtn,
                     "note": note,
                     "streak":streak,
                     "percentage" : percentage,
                     "trackingDays":trackingDays
        ] as [String : Any]
        db.collection("UsersData").document(user.uid!)
            .collection("PracticedData").document(practiceName)
            .setData(datas, merge: true)
    }
    func addPracticeHistoryToFirebase(practiceName: String, comDelFlag: Bool, date: Date, dss: Int, td: Int,user:User){
        let datas = ["id": practiceName,
                     "practiceName": practiceName,
                     "comDelFlag": comDelFlag,
                     "date": date,
                     "dss": dss,
                     "td": td,
        ] as [String : Any]
        db.collection("UsersData").document(user.uid!)
            .collection("PracticedHistory").document(practiceName)
            .setData(datas)
    }
    func fetchUserData(email: String,completionHandler: @escaping userAdded) {
        var uName = ""
        var image : Data?
        var flag = false
        print("this begin \(email)")
        let ref = db.collection("dap_users").whereField("uid", isEqualTo: email)
        ref.addSnapshotListener { (snapshot, error) in
            if error != nil
            {
                print("this begin \(String(describing: error))")
            }
            else {
                if snapshot != nil {
                    for document in snapshot!.documents {
                        uName = document.data() ["username"] as! String
                        image = document.data() ["image"] as? Data
                        print("this begin \(email)")
                        print("this uName \(uName)")
                        flag = true
                    }
                    print("this end \(email)")
                    completionHandler(flag,uName,image!)
                   
                }else{
                    completionHandler(flag,uName,image!)
                }
               
               
            }
        }
    }
        
    func FetchPractices(uid:String,completion :  @escaping  practiceAdded) {
        print("this start \(uid)")
        var practice = "",image_name = "",value = "",user = "",encourage = "",goals = "",remindswitch = false,practiceDays = 0
        var date = Timestamp()
       
        
        let ref =  db.collection("UsersData").document(uid)
                   .collection("Practices").whereField("is_deleted", isEqualTo: false)
        ref.addSnapshotListener { (snapshot, error) in
            if error != nil
            {
                print(error!)
            }
            else {
                if snapshot != nil {
                    for document in snapshot!.documents {
                         practice = document.data() ["practiceName"] as! String
                         image_name = document.data() ["image_name"] as! String
                         date = document.data() ["date"] as! Timestamp
                         user = document.data() ["user"] as! String
                         value = document.data() ["value"] as! String
                         encourage = document.data() ["encourage"] as! String
                         remindswitch = document.data() ["remindswitch"] as! Bool
                         goals = document.data() ["goals"] as! String
                        practiceDays = document.data() ["practiced-days"] as! Int
                   
                        let practices = UserPractices()
                        let UserObject = CurrentUser()
                        let userob = UserObject.getUserObject(email: user)
                        let result = practices.addPractices(practice: practice, image_name: image_name, date: date.dateValue().dateFormate()!, user: userob!, value: value, encourage: encourage, remindswitch: remindswitch, goals: goals, practiceDay: practiceDays)
                        if result == 0 {
                            self.FetchPracData(uid: uid, id: practice)
                        }
                }
                   
                    completion(true)
                }else{
                    completion(false)
                }
            
            }
        }
        
    }
    func FetchPracData(uid:String,id:String)  {
        print("this start \(uid)")
        var practiceObject = "",toggleBtn = false,note = "",user = "",streak = 0,
            percentage = 0,trackingDays = 0
        var currentDate = Timestamp()
       
        
        let ref =  db.collection("UsersData").document(uid)
                   .collection("PracticedData").whereField("id", isEqualTo: id)
        ref.addSnapshotListener { (snapshot, error) in
            if error != nil
            {
                print(error!)
            }
            else {
                if snapshot != nil {
                    for document in snapshot!.documents {
                        practiceObject = document.data() ["practiceName"] as! String
                        currentDate = document.data() ["PracticedDate"] as! Timestamp
                        user = document.data() ["user"] as! String
                        streak = document.data() ["streak"] as! Int
                        percentage = document.data() ["percentage"] as! Int
                        trackingDays = document.data() ["trackingDays"] as! Int
                        note = document.data() ["note"] as! String
                        toggleBtn = document.data() ["toggleStarBtn"] as! Bool
                        
                            let practiceData = UserPracticesData()
                            let UserObject = CurrentUser()
                            let userob = UserObject.getUserObject(email: user)
                        practiceData.addPracticedData(toggleBtn: toggleBtn, practiceObject: practiceObject, currentDate: currentDate.dateValue().dateFormate()!, userObject: userob, note: note, tracking_days: trackingDays, streak: streak, percentage: percentage
                            )
                        
                }
                    
                }
            }
        }
    }
    func fetchHistory(uid: String,email:String) {
        let ref =  db.collection("UsersData").document(uid)
                   .collection("PracticedHistory")
        ref.addSnapshotListener { (snapshot, error) in
            if error != nil
            {
                print(error!)
            }
            else {
                if snapshot != nil {
                    for document in snapshot!.documents {
                        let practiceName = document.data() ["practiceName"] as! String
                        let date = document.data() ["date"] as! Timestamp
                        let dss = document.data() ["dss"] as! Int
                        let td = document.data() ["td"] as! Int
                        let comDelFlag = document.data() ["comDelFlag"] as! Bool
                        
                            let practiceHistory = PracticedHistory()
                            let UserObject = CurrentUser()
                            let userob = UserObject.getUserObject(email: email)
                        _ = practiceHistory.addPracticeHistory(practiceName: practiceName, comDelFlag: comDelFlag, date: date.dateValue().dateFormate()!, dss: dss, td: td, userOb: userob!)
                        
                }
                    
                }
            }
        }
    }
}
