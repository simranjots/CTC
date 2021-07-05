import Foundation
import CoreData
import UIKit

class CurrentUser {
    
    var users = [User]()
    let db = FirebaseDataManager()
    typealias userSignIn = (Bool) -> Void
    typealias userAdded = (Int) -> Void
    
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addUser(name: String, email: String, password: String,from : String,completionHandler: @escaping userAdded){
        
        loadUser()
        
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
            newUser.password = password
            newUser.isloggedin = true
            let result = saveUser()
            if result == 0 {
                if from == "signUp" {
                    completionHandler(result)
                }else {
                    db.fetchHistory(email: email)
                    db.FetchPractices(email: email) { success in
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
    func signInUser(userName : String, email : String ,password : String,Completion :@escaping userSignIn ) {
        let user = getUserObject(email: email)
        if user == nil {
            db.fetchUserData(email: email, completionHandler: {(success, value) -> Void in
                if(success){
                    self.addUser(name: value, email: email, password: password, from: "signIn", completionHandler: {(flag) -> Void in
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
    
    
    func updateUser(oldEmail: String,newEmail: String, name: String, dob: String, password: String) -> Int {
        
        let userObject = getUserObject(email: oldEmail)
        
        userObject!.name = name
        userObject!.email = newEmail
        userObject!.dob = dob
        userObject!.password = password
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
