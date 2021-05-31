import UIKit

class LoginViewController: UIViewController {
    
    
    //Dabase initilizers
    var dbHelper: DatabaseHelper!
    var firebaseHelper: FirebaseHelper!
    var userObjectPass: User!
    
    //Outlets
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var gmailSignInButton: UIButton!
    @IBOutlet var facebookSignInButton: UIButton!
    
    // to store the current active textfield
    var activeTextField : UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbHelper = DatabaseHelper()
        setUpElements()
        
    }
    
    
    //Set the properties of login screen elements
    func setUpElements() {
        
        //Add textField Images
        guard let emailTextFieldImage = UIImage(named: "Email-1") else { return }
        guard let passwordTextFieldImage = UIImage(named: "Password-1") else { return }
        
        //Style the textFields
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        //Style the buttons
        Utilities.styleButton(signInButton)
        Utilities.styleButton(gmailSignInButton)
        Utilities.styleButton(facebookSignInButton)
        
        //Set textField Images
        Utilities.addTextFieldImage(textField: emailTextField, andImage: emailTextFieldImage)
        Utilities.addTextFieldImage(textField: passwordTextField, andImage: passwordTextFieldImage)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        dbHelper = DatabaseHelper()
        firebaseHelper = FirebaseHelper()
        
        userObjectPass = dbHelper.checkLoggedIn()
        
        
        if (userObjectPass != nil){

            performSegue(withIdentifier: "MainTabbedBar", sender: self)
        }
        
    }
    
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        
        view.endEditing(true)
   
        var email = emailTextField.text!
        email = email.lowercased()
        
        let userDataFromFirebase = firebaseHelper.getUserFromFirebase(userEmail: email)
        
        let password = passwordTextField.text!
        
        if(email.isValidEmail){
            
            if(password.isValidPassword){
                
                let resultUsers = dbHelper.getUser()
                
                var result = false
                
                for user in resultUsers{
                    
                    if(user.email == email && user.password == password){
                        
                        userObjectPass = user
                        result = true
                        
                        dbHelper.updateLoginStatus(status: true, email: user.email!)
                        break
                        
                    }
                }
                
                
                
                if result {
                    performSegue(withIdentifier: "MainTabbedBar", sender: self)
                }
                else {
                    
                    showAlert(title: "Login Fail", message: "Invalid Login Credentials. . .", buttonTitle: "Try Again")
                    
                    
                    print("no")
                }
            }else{
                
                showToast(message: "Enter Valid Password", duration: 2.0)
                
            }
            
        }else{
            
            showToast(message: "Enter Valid Email", duration: 2.0)
            
        }
        
    }
    
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func gmailSignInButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func faceBookSignInButtonTapped(_ sender: UIButton) {
    }
    
    
}

extension LoginViewController : UITextFieldDelegate {
//  // when user select a textfield, this method will be called
//  func textFieldDidBeginEditing(_ textField: UITextField) {
//    // set the activeTextField to the selected textfield
//    self.activeTextField = textField
//  }
//
//  // when user click 'done' or dismiss the keyboard
//  func textFieldDidEndEditing(_ textField: UITextField) {
//    self.activeTextField = nil
//  }
}
