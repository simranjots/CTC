import Foundation
import CoreData
import Firebase
import UIKit

class CurrentUser {
    
    var users = [User]()
    let db = FirebaseDataManager()
    let database = Firestore.firestore()
    typealias userSignIn = (Bool) -> Void
    typealias userAdded = (Int) -> Void
    
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addUser(name: String, email: String, password: String,uid : String,from : String,image: Data?,completionHandler: @escaping userAdded){
        
        loadUser()
        let user = getUserObject(email: email)
        if from == "GsignIn"{
            if user?.email == email {
                user!.isloggedin = true
                _ = saveUser()
                completionHandler(0)
            }else{
                let newUser = User(context: self.context)
                newUser.name = name
                newUser.email = email
                newUser.uid = uid
                newUser.image = image
                newUser.password = password
                newUser.isloggedin = true
                _ = saveUser()
                completionHandler(0)
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
                        completionHandler(result)
                    }else {
                        db.fetchHistory(uid: uid, email: email)
                        db.FetchPractices(uid: uid) { success in
                            if success {
                              completionHandler(result)
                            }else{
                                completionHandler(result)
                            }
                        }
                    }
                  }
                
            }else {
                print("User Exist")
                completionHandler(2)
                
            }
        }
        
        
        
    }
    func signInUser(userName : String, email : String ,password : String,uid: String,Completion :@escaping userSignIn ) {
        let user = getUserObject(email: email)
        if user == nil {
            db.fetchUserData(email: email, completionHandler: {(success, value,image) -> Void in
                if(success){
                    self.addUser(name: value, email: email, password: password, uid: uid, from: "signIn", image: image, completionHandler: {(flag) -> Void in
                        if flag == 0
                        {
                            Completion(true)
                        }
                        
                    })
                    
                }else{
                    Completion(false)
                }
            })
            
            
        }else{
            if(user!.email == email && user!.password == password){
                user!.isloggedin = true
                    _ = saveUser()
                    Completion(true)
                }else{
                    Completion(false)
                }
            
           
            
        }
        
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
    
    
    func updateUser(oldEmail: String,newEmail: String, name: String, password: String,image: Data) -> Int {
        
        let userObject = getUserObject(email: oldEmail)
        
        userObject!.name = name
        userObject!.email = newEmail
        userObject!.password = password
        userObject?.image = image
        let result = saveUser()
        if result == 0 {
            database.collection("dap_users").document(userObject!.uid!).setData(["username": name, "uid": newEmail,"image" : image],merge: true) { error in
                if error != nil {
                    print(error as Any)
                }
            }
        }
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
