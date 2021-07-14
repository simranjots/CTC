import Foundation
class userModel {


var uid: String?
var name: String?
var email: String?
var imageLink : String?
var verified : String?

    
    init(uid: String?,name: String?,email: String?,imageLink : String?,verified : String?){

    self.uid = uid
    self.name = name
    self.email = email
    self.imageLink = imageLink
    self.verified = verified
 

  }
    convenience init(dictionary: [String : Any]) {
         let uid = dictionary["uid"] as? String ?? ""
         let name = dictionary["name"] as? String ?? ""
         let email = dictionary["email"] as? String ?? ""
         let imageLink =  dictionary["imageLink"] as? String ?? ""
        let verified =  dictionary["verified"] as? String ?? ""
        self.init(uid: uid, name: name, email: email,imageLink: imageLink,verified: verified)
     }
 }
