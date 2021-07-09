import Foundation
import CoreData
import Firebase
import UIKit
import FirebaseStorage

class CurrentUser {
    
    var users = [User]()
    let db = FirebaseDataManager()
    let database = Firestore.firestore()
    // Create a root reference
    let storageRef = Storage.storage().reference()
    typealias userSignIn = (Bool) -> Void
    typealias userAdded = (Int) -> Void

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addUser(name: String, email: String, password: String,image : Data?,uid : String,from : String)-> Int{
        loadUser()
        let user = getUserObject(email: email)
        if from == "GsignIn"{
            if user?.email == email {
                user!.isloggedin = true
                let output = saveUser()
                return output
               
            }else{
                let newUser = User(context: self.context)
                newUser.name = name
                newUser.email = email
                newUser.uid = uid
                newUser.password = password
                newUser.image = image
                newUser.isloggedin = true
                let output = saveUser()
                return output
            }
            
        }else{
            var userNotExist: Bool = true
            
            for user in users{
                
                if(user.email == email){
                    userNotExist = false
                }
                
            }
            
            if(userNotExist){
                let newUser = User(context: self.context)
                newUser.name = name
                newUser.email = email
                newUser.uid = uid
                newUser.password = password
                newUser.image = image
                newUser.isloggedin = true
                let result = saveUser()
                if result == 0 {
                    if from == "signUp" {
                        return result
                    }else {
                        db.fetchHistory(uid: uid, email: email)
                        db.FetchPractices(uid: uid)
                        return result
                    }
                }
                
            }else {
                print("User Exist")
              return 2
                
            }
        }
        
       return 0
        
    }
    
    
    func getUserObject(email: String) -> User?{
        var Singleuser = User()
        let request:NSFetchRequest<User> = User.fetchRequest()
        do {
            users = try context.fetch(request)
            
        } catch let err {
            print(err)
        }
        for user in users{
            if user.email == email {
                Singleuser = user
                return Singleuser
            }
            
        }
        return nil
    }
    
    
    func updateUser(oldEmail: String,newEmail: String, name: String, password: String,image: Data?) -> Int {
        
        let userObject = getUserObject(email: oldEmail)
        
        userObject!.name = name
        userObject!.email = newEmail
        userObject!.password = password
        userObject?.image = image
        let result = saveUser()
        if result == 0 {
           
            let spaceRef = storageRef.child("images/\(userObject!.uid!)/\((userObject?.image)!)")
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            spaceRef.putData((userObject?.image)!, metadata: metaData) { (StorageMetadata, error) in
                guard StorageMetadata != nil else{
                    print("oops an error occured while data uploading")
                    return
                }
                spaceRef.downloadURL { (url, error) in
                   guard let downloadURL = url else {
                     // Uh-oh, an error occurred!
                     return
                   }
                    let urlString: String = downloadURL.absoluteString
                    self.database.collection("dap_users").document(userObject!.uid!)
                        .setData(["uid":Auth.auth().currentUser!.uid,
                                  "name": name,
                                  "email":newEmail,
                                  "imageLink":urlString],merge: true) { error in
                        if error != nil {
                            print(error as Any)
                        }
                    }
                 }
               }
            
           
        }
        return result
        
        
    }
    func updatepassword(Email: String, password: String) -> Int {
        
        let userObject = getUserObject(email: Email)
        userObject!.password = password
        userObject!.isloggedin = true
        let result = saveUser()
        return result
        
        
    }
    
    func passwordCheck(email: String, password: String) -> Bool {
        
        let request : NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "email = %@ && password =%@", argumentArray: [email,password])
        
        loadUser(with: request)
        if users.count == 0{
            return false
        }else{
            return true
        }
        
    }
    func checkUser(email: String) -> Bool{
        loadUser()
        for user in users {
            if user.email == email{
                return true
            }
        }
        return false
    }
    
    func updateLoginStatus(status: Bool, email: String) -> Int{
        
        loadUser()
        for user in users {
            if user.email == email{
                user.isloggedin = status
                let result = saveUser()
                return result
            }
        }
        return 0
    }
    
    func checkLoggedIn() -> User!{
        loadUser()
        for user in users{
            if user.isloggedin == true{
                return user
            }
        }
        return nil
    }
    
    
    func saveUser()-> Int  {
        
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
            return 1
        }
        return 0
    }
    
    func loadUser(with request:NSFetchRequest<User> = User.fetchRequest()) {
        
        do {
            users = try context.fetch(request)
            
        } catch let err {
            print(err)
        }
    }
    
}
