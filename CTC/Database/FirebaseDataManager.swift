import Foundation
import Firebase
class FirebaseDataManager {
    
    let db = Firestore.firestore()
    
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
                     "is_deleted": false,
                     "percentage" : 0
        ] as [String : Any]
        db.collection("UsersData").document(user.email!)
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
        db.collection("UsersData").document(user.email!)
            .collection("Practices").document(oldPractice)
            .setData(datas, merge: true)
    }
    
    func updateSinglePractices(valueName: String,value : Any){
        let practiceStringUpdate = db.collection("UsersData").document("DC")
            .collection("Practices").document("practiceName")
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
    func AddpracticedDataToFirebase(toggleStarBtn: Bool, practiceName: String, PracticedDate: Date,user: User,note: String,streak:Int32,trackingDays:Int32){
        let datas = ["id": practiceName,
                     "practiceName": practiceName,
                     "PracticedDate": PracticedDate,
                     "user": user.email!,
                     "toggleStarBtn": toggleStarBtn,
                     "note": note,
                     "streak":streak,
                     "trackingDays":trackingDays
        ] as [String : Any]
        db.collection("UsersData").document(user.email!)
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
        db.collection("UsersData").document(user.email!)
            .collection("PracticedHistory").document(practiceName)
            .setData(datas)
    }
}
