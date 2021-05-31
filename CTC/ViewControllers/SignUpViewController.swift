

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate {

    
    var dbHelper: DatabaseHelper!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var backToSignIn: UIButton!
    
   
    //var activeField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbHelper = DatabaseHelper()
        setUpElements()
        
    }
    
    //Set the properties of Sign Up screen elements
    func setUpElements() {
        
        //Add textField images
        guard let nameTextFieldImage = UIImage(named: "Profile-Selected") else { return }
        guard let emailTextFieldImage = UIImage(named: "Email-1") else { return }
        guard let passwordTextFieldImage = UIImage(named: "Password-1") else { return }
        
        //Style Texfields
        Utilities.styleTextField(nameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        //Style Sign Up button
        Utilities.styleButton(signUpButton)
        
        //Set textField Images
        Utilities.addTextFieldImage(textField: nameTextField, andImage: nameTextFieldImage)
        Utilities.addTextFieldImage(textField: emailTextField, andImage: emailTextFieldImage)
        Utilities.addTextFieldImage(textField: passwordTextField, andImage: passwordTextFieldImage)
    }
    
    
 
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
   
        let name = nameTextField.text!
        var email = emailTextField.text!
        email = email.lowercased()
        let password = passwordTextField.text!
        
        if(!name.isEmpty && !email.isEmpty && !password.isEmpty){
            
            if(email.isValidEmail){
                if(password.isValidPassword){
                    
                    let resultFlag = dbHelper.addUser(name: name, email: email, password: password)
                    let fireRef = FirebaseHelper()
                    fireRef.addUser(userName: name, userEmail: email, userPassword: password)
                    
                    if(resultFlag == 1){
                        
                        showAlert(title: "Warning", message: "User Already Exist", buttonTitle: "Try Again")
                        
                        
                    }else if (resultFlag == 2){
                        
                        showAlert(title: "Error", message: "Please Report an error. . .", buttonTitle: "Try Again")
                        
                    }else if (resultFlag == 0){
                        performSegue(withIdentifier: "MainTabbedBar", sender: self)
                    }
                    
                }else{
                    showToast(message: "Enter Valid Password", duration: 2.0)
                }
            }else{
                showToast(message: "Enter Valid Email", duration: 2.0)
            }
          
            
        }
        else{
            
            print("fill the form")
            
        }
        
    }
  
}
