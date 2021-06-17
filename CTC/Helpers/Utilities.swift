import Foundation
import UIKit

class Utilities {
    
    //MARK: -  Textfield & TextView stylling
    
    static func styleTextField(_ textfield:UITextField) {
        
        //Textfield style
        textfield.layer.borderWidth = 1.0
        textfield.layer.cornerRadius = 8.0
        textfield.layer.borderColor = UIColor.init(red: 115/255, green: 115/255, blue: 115/255, alpha: 1).cgColor
    }
    
    static func addBottomLineToTextField(_ textField: UITextField) {
        
        //Create the bottom line
        let bottomLine  = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 115/255, green: 115/255, blue: 115/255, alpha: 1).cgColor
        
        //Remove border on textField
        textField.borderStyle = .none
        
        //Add the line to the textField
        textField.layer.addSublayer(bottomLine)
    }
    
    
    static func styleTextView(_ textView:UITextView) {
        
        //TextView style
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 8.0
        textView.layer.borderColor = UIColor.init(red: 115/255, green: 115/255, blue: 115/255, alpha: 1).cgColor
    }
    
    //MARK: - Set TextField left image
    static func addTextFieldImage(textField: UITextField, andImage image: UIImage) {
        
        //Create textField view
        let textFieldView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        //Create textField subview and add image
        let textFieldImageView = UIImageView(image: image)
        
        //Set subview frame
        textFieldImageView.frame = CGRect(x: 15, y: 8, width: 25, height: 25)
        
        textFieldImageView.tintColor = .darkGray
        
        //Add subview
        textFieldView.addSubview(textFieldImageView)
        
        //Set leftside textField properties
        textField.leftView = textFieldView
        textField.leftViewMode = .always
    }
    
    //MARK: -  ImageView Stylling
    
    static func styleImageView(_ imageView:UIImageView) {
        
        //TextView style
        imageView.layer.borderWidth = 1.0
        imageView.layer.cornerRadius = 8.0
        imageView.layer.borderColor = UIColor.init(red: 115/255, green: 115/255, blue: 115/255, alpha: 1).cgColor
    }
    
    //MARK: -  Buttons Stylling
    
    static func styleButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 62/255, green: 178/255, blue: 174/255, alpha: 1)
        button.layer.cornerRadius = 8.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 1
        if #available(iOS 13.0, *) {
            button.layer.borderColor = CGColor(red: 62/255, green: 178/255, blue: 174/255, alpha: 1)
        } else {
            button.layer.borderColor = UIColor.systemTeal.cgColor
        }
        button.layer.cornerRadius = 8.0
        //button.tintColor = UIColor.init(red: 62/255, green: 178/255, blue: 174/255, alpha: 1)
    }
    
    static func styleGmailButton(_ button:UIButton) {
        
        //Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 234/255, green: 67/255, blue: 53/255, alpha: 1)
        button.layer.cornerRadius = 8.0
        button.tintColor = UIColor.white
    }
    
    static func styleFacebookButton(_ button:UIButton) {
        //Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 66/255, green: 103/255, blue: 178/255, alpha: 1)
        button.layer.cornerRadius = 8.0
        button.tintColor = UIColor.white
    }
    
    //MARK: - Regular expressions for Email and Password
    static func isPasswordValid(_ password:String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,64}")
        return passwordTest.evaluate(with: password)
    }
    
    static func isEmailValid(_ email:String) -> Bool {
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailTest.evaluate(with: email)
    }
    
    //MARK: - Color constants
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static let primaryTextColor = rgb(red: 62, green: 178, blue: 174)
    static let primaryBorderColor = rgb(red: 115, green: 115, blue: 115)
    static let gradientColor1 = rgb(red: 78, green: 114, blue: 186)
    static let gradientColor2 = rgb(red: 62, green: 178, blue: 174)
    
    func addColorGradient(view: UIView) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [Utilities.gradientColor1.cgColor, Utilities.gradientColor2.cgColor]
        view.layer.addSublayer(gradientLayer)
        
    }
}
