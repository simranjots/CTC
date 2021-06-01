import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        //Textfield style
        textfield.layer.borderWidth = 3.0
        textfield.layer.cornerRadius = 10.0
        textfield.layer.borderColor = UIColor.init(red: 115/255, green: 115/255, blue: 115/255, alpha: 1).cgColor
    }
    
    static func addTextFieldImage(textField: UITextField, andImage image: UIImage) {
        
        //Create textField view
        let textFieldView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        //Create textField subview and add image
        let textFieldImageView = UIImageView(image: image)
        
        //Set subview frame
        textFieldImageView.frame = CGRect(x: 15, y: 8, width: 25, height: 25)
        
        //Add subview
        textFieldView.addSubview(textFieldImageView)
        
        //Set leftside textField properties
        textField.leftView = textFieldView
        textField.leftViewMode = .always
    }
    
    
    
    static func styleButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 62/255, green: 178/255, blue: 174/255, alpha: 1)
        button.layer.cornerRadius = 10.0
        button.tintColor = UIColor.white
    }
    
    static func isPasswordValid(_ password:String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func isEmailValid(_ email:String) -> Bool {
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailTest.evaluate(with: email)
    }
    
    
    
}
