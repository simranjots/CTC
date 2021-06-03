
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
        
   
        ref.observe(.childAdded) { (dataSnapshot) in
            print(dataSnapshot)
        }
        return finalUser
    }
    
    
}
