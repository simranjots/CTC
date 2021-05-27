//
//  DatabaseHelper.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-02-06.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class UserData {
    
    let context: NSManagedObjectContext?
    
    init() {
    
        context = (UIApplication.shared.delegate  as? AppDelegate)?.persistentContainer.viewContext
        
    }
    

    func addUser(name: String, email: String, password: String){
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context!) as! User
        
        newUser.name = name
        newUser.email = email
        newUser.password = password
        
        do {
            try context?.save()
        } catch let err {
            print(err)
        }
        print("User \(name) added")
    }
    
    
    func getUser(email: String, password:String) -> Bool{
        
        
        
        
        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
           let currentUsers = try context?.fetch(featchRequest) as? [User]
            
            for user in currentUsers!{
            
            print("Database name : \(user.email)")
            print("Database password : \(user.password)")
            
            if(user.email == email && user.password == password){
                
                return true
                
            }else{
                
                return false
                
            }
            }
        } catch let err {
            print(err)
        }
        
        
       return false
        
    }
    
}
