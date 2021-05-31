import UIKit

class LoginViewController: UIViewController {
    
    
    //Dabase initilizers
    var dbHelper: DatabaseHelper!
    var firebaseHelper: FirebaseHelper!
    var userObjectPass: User!
    
    //Outlets
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
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
        
        // to dismiss keyboard on tap out side
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        
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
    
    
    // to dismiss keyboard on tap out side
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
    }
       
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//
//          // if keyboard size is not available for some reason, dont do anything
//          return
//        }
//
//        var shouldMoveViewUp = false
//
//        // if active text field is not nil
//        if let activeTextField = activeTextField {
//
//            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
//
//          let topOfKeyboard = self.view.frame.height - keyboardSize.height
//
//          // if the bottom of Textfield is below the top of keyboard, move up
//          if bottomOfTextField > topOfKeyboard {
//            shouldMoveViewUp = true
//          }
//        }
//
//        if(shouldMoveViewUp) {
//          self.view.frame.origin.y = 0 - keyboardSize.height
//        }
//    }

//    @objc func keyboardWillHide(notification: NSNotification) {
//      // move back the root view origin to zero
//      self.view.frame.origin.y = 0
//    }
//
//
    
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
                    presentingViewController?.dismiss(animated: true, completion: nil)
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
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "signup") as! SignUpViewController
        self.present(vc, animated: true, completion: nil)
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "loginToHome":
            let tbvc = segue.destination as! UITabBarController
            let navvc = tbvc.viewControllers![0] as! UINavigationController
            let destination = navvc.viewControllers[0] as! HomeViewController
            
            destination.userObject = userObjectPass
        default: break
            
        }
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
