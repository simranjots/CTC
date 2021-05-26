
import Foundation
import FirebaseDatabase

class FirebaseHelper {
    
    var ref : DatabaseReference!
    var retriveRef: DatabaseReference!
    
    init() {
        
        ref = Database.database().reference().child("Users")
        
        
    }
    
    func addUser(userName: String, userEmail: String, userPassword: String) {
        
        
        ref.childByAutoId().setValue(["userName" : userName, "userEmail": userEmail, "userPassword": userPassword]) { (err, ref) in
            if(err != nil){
                
                print("Firebase Database Error: \(err)")
                
            }
        }
        
    }
    
    func getUserFromFirebase(userEmail: String) -> [String: String]?{
        
        var finalUser : [String: String]?
        
//        ref.observe(DataEventType.value) { (DataSnapshot) in
//            if DataSnapshot.childrenCount > 0{
//
//                for user in DataSnapshot.children.allObjects as! [DataSnapshot]{
//
//                    let userObject = user.value as? [String:String]
//
//                    if(userObject!["userEmail"] == userEmail){
//
//                        finalUser = ["userName": userObject!["userName"],"userEmail": userObject!["userEmail"],"userPassword": userObject!["userPassword"],"dob": userObject!["dob"]] as! [String : String]
//
//
//                    }
//
//                }
//
//            }
//        }
        
        
        
//        ref.observeSingleEvent(of: .value, with: { (snapShot) in
//
//            print(snapShot)
//
//        })
//
        
        
        ref.observe(.childAdded) { (dataSnapshot) in
            print(dataSnapshot)
        }
        return finalUser
    }
    
    
}
