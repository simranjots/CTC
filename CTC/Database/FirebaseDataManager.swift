import Foundation
import Firebase
import FirebaseFirestore
import UIKit
class FirebaseDataManager {
    
    let db = Firestore.firestore()
    typealias practiceAdded = (Bool)->Void
    typealias practiceDataAdded = (Bool)->Void
    
    func addPracticesToFirebase(practiceName: String, image_name: String,date: Date, user: User,value : String,encourage : String,remindswitch : Bool,goals : String,id:String)  {
        let datas = ["id": id,
                     "practiceName": practiceName,
                     "image_name": image_name,
                     "date": date,
                     "user": user.email!,
                     "value": value,
                     "encourage": encourage,
                     "remindswitch": remindswitch,
                     "goals": goals,
                     "is_completed": false,
                     "is_deleted": false
                     
        ] as [String : Any]
        db.collection("UsersData").document(user.uid!)
            .collection("Practices").document(id)
            .setData(datas)
    }
    func updatePracticesInFirebase(oldPractice: String, newPractice: String,image_name: String, user: User,value : String,encourage : String,remindswitch : Bool,goals : String,date: Date,id:String)  {
        let datas = ["id": id,
                     "practiceName": newPractice,
                     "image_name": image_name,
                     "user": user.email!,
                     "value": value,
                     "encourage": encourage,
                     "remindswitch": remindswitch,
                     "goals": goals
        ] as [String : Any]
        db.collection("UsersData").document(user.uid!)
            .collection("Practices").document(id)
            .updateData(datas)
    }
    
    func updateSinglePractices(collectionName : String ,valueName: String,value : Any,document : String,uid : String){
        let practiceStringUpdate = db.collection("UsersData").document(uid)
            .collection("\(collectionName)").document(document)
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
    func AddpracticedDataToFirebase(toggleStarBtn: Bool, practiceName: String, PracticedDate: Date,user: User,note: String,streak:Int32,trackingDays:Int32,uid:String){
        let data = ["id": uid,
                    "practiceName": practiceName,
                    "PracticedDate": PracticedDate,
                    "user": user.email!,
                    "toggleStarBtn": toggleStarBtn,
                    "note": note,
                    "streak":streak,
                    "trackingDays":trackingDays
        ] as [String : Any]
        db.collection("UsersData").document(user.uid!)
            .collection("PracticedData").document(uid)
            .setData(data, merge: true)
    }
    func AddnotesToFirebase(practiceName: String,user: User,uid: String,note: String ,PracticedDate: Date) {
        let datas = ["practiceName":practiceName,
                     "uid" : uid,
                     "note": note,
                     "notesDate": PracticedDate ] as [String : Any]
        db.collection("UsersData").document(user.uid!)
            .collection("PracticedData").document(practiceName).collection("Notes").document("\(PracticedDate)")
            .setData(datas)
    }
    func addPracticeHistoryToFirebase(id :String,practiceName: String, comDelFlag: Bool, date: Date, dss: Int, td: Int,user:User){
        let datas = ["id": id,
                     "practiceName": practiceName,
                     "comDelFlag": comDelFlag,
                     "date": date,
                     "dss": dss,
                     "td": td,
                     "isRestore" : false
        ] as [String : Any]
        db.collection("UsersData").document(user.uid!)
            .collection("PracticedHistory").document(id)
            .setData(datas)
    }
    func FetchTUserData(email: String,completion: @escaping ([userModel]) -> Void) {
        
        let ref = Firestore.firestore().collection("dap_users").whereField("email", isEqualTo: email)
        ref.getDocuments() { (snapshot, error) in
            if error != nil
            {
                
            }
            else {
                completion(snapshot!.documents.compactMap({userModel(dictionary: $0.data())} ))
                return
                
            }
            
            
        }
    }
    
    func FetchPractices(puid:String,completion : @escaping practiceAdded) {
        print("this start \(puid)")
        
        var practice = "",image_name = "",value = "",user = "",encourage = "",goals = "",remindswitch = false,uid = ""
        var date = Timestamp()
        
        
        db.collection("UsersData").document(puid)
            .collection("Practices").whereField("is_deleted", isEqualTo: false).getDocuments(){ (snapshot, error) in
                if error != nil
                {
                    print(error!)
                }
                else {
                    
                    if snapshot != nil {
                        for document in snapshot!.documents {
                            let data = document.data()
                            uid = data ["id"] as! String
                            practice = document.data() ["practiceName"] as! String
                            image_name = document.data() ["image_name"] as! String
                            date = document.data() ["date"] as! Timestamp
                            user = document.data() ["user"] as! String
                            value = document.data() ["value"] as! String
                            encourage = document.data() ["encourage"] as! String
                            remindswitch = document.data() ["remindswitch"] as! Bool
                            goals = document.data() ["goals"] as! String
                            
                            
                            let practices = UserPractices()
                            let UserObject = CurrentUser()
                            let userob = UserObject.getUserObject(email: user)
                            let result = practices.addPractices(practice: practice, image_name: image_name, date: date.dateValue().dateFormate()!, user: userob!, value: value, encourage: encourage, remindswitch: remindswitch, goals: goals, Fuid: uid)
                            if result == 0 {
                                self.FetchPracData(uid: uid, id: puid, completionhandler: {(flag) -> Void in
                                    if(flag){
                                        completion(true)
                                    }
                                })
                               
                            }
                        }
                        
                    }
                    else{
                        completion(true)
                    }
                    
                }
            }
        
        
    }
    func FetchPracData(uid:String,id:String,completionhandler : @escaping practiceAdded) {
        print("this data start \(uid)")
        
        var practiceObject = "",toggleBtn = false,puid = "",user = "",streak = 0,trackingDays = 0,note = ""
        var currentDate = Timestamp()
        
        
        let ref =   db.collection("UsersData").document(id)
            .collection("PracticedData").whereField("id", isEqualTo: uid)
        ref.getDocuments() { (snapshot, error) in
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
                        trackingDays = document.data() ["trackingDays"] as! Int
                        puid = document.data() ["id"] as! String
                        note = document.data() ["note"] as! String
                        toggleBtn = document.data() ["toggleStarBtn"] as! Bool
                        print("check 1\(puid)")
                        let practiceData = UserPracticesData()
                        let UserObject = CurrentUser()
                        let userob = UserObject.getUserObject(email: user)
                        practiceData.addPracticedData(toggleBtn: toggleBtn, practiceObject: practiceObject, currentDate: currentDate.dateValue().dateFormate()!, userObject: userob, uid: puid, tracking_days: trackingDays, streak: streak, note: note)
                        
                        completionhandler(true)
                    }
                    
                }else{
                    completionhandler(true)
                }
            }
        }
    }
    func FetchNotes(Useruid:String,practiceName:String) ->Bool? {
        var result : Bool?
        var uid = "",note = "",practice = ""
        var notesDate = Timestamp()
        let ref =  db.collection("UsersData").document(Useruid)
            .collection("PracticedData").document(practiceName).collection("Notes")
        ref.getDocuments(){ (snapshot, error) in
            if error != nil
            {
                print(error!)
            }else{
                if snapshot != nil {
                    for document in snapshot!.documents {
                        uid = document.data() ["uid"] as! String
                        notesDate = document.data() ["notesDate"] as! Timestamp
                        note = document.data() ["note"] as! String
                        practice = document.data() ["practiceName"] as! String
                        let practiceNotes = PracticeNotes()
                        practiceNotes.addNotesData(uid: uid, currentDate: notesDate.dateValue().dateFormate()!, note: note, practiceName: practice)
                    }
                    result = true
                }else{
                    result = false
                }
            }
            
        }
        return result
    }
    func  fetchHistory(uid: String,email:String)->Bool? {
        var result : Bool?
        
        let ref =  db.collection("UsersData").document(uid)
            .collection("PracticedHistory").whereField("isRestore", isEqualTo: false)
        ref.getDocuments() { (snapshot, error) in
            if error != nil
            {
                print(error!)
            }
            else {
                if snapshot != nil {
                    for document in snapshot!.documents {
                        let practiceName = document.data() ["practiceName"] as! String
                        let id = document.data() ["id"] as! String
                        let date = document.data() ["date"] as! Timestamp
                        let dss = document.data() ["dss"] as! Int
                        let td = document.data() ["td"] as! Int
                        let comDelFlag = document.data() ["comDelFlag"] as! Bool
                        
                        let practiceHistory = PracticedHistory()
                        let UserObject = CurrentUser()
                        let userob = UserObject.getUserObject(email: email)
                        _ = practiceHistory.addPracticeHistory(hid: id, practiceName: practiceName, comDelFlag: comDelFlag, date: date.dateValue().dateFormate()!, dss: dss, td: td, userOb: userob!)
                        result = true
                    }
                }else{
                    result = false
                }
                
            }
        }
        return result
    }
}
