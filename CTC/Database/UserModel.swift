import Foundation
class userModel {


var uid: String?
var name: String?
var email: String?
var imageLink : String?

    
    init(uid: String?,name: String?,email: String?,imageLink : String?){

    self.uid = uid
    self.name = name
    self.email = email
    self.imageLink = imageLink
    
 

  }
    convenience init(dictionary: [String : Any]) {
         let uid = dictionary["uid"] as? String ?? ""
         let name = dictionary["name"] as? String ?? ""
         let email = dictionary["email"] as? String ?? ""
         let imageLink =  dictionary["imageLink"] as? String ?? ""
        self.init(uid: uid, name: name, email: email,imageLink: imageLink)
     }
 }
