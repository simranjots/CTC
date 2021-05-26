import UIKit

class LoginViewController: UIViewController {
    
    // variables
    var dbHelper: DatabaseHelper!
    var firebaseHelper: FirebaseHelper!
    
    var userObjectPass: User!
    ////variables
    
    
    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    // to store the current active textfield
    var activeTextField : UITextField? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add delegate to all textfields to self (this view controller)
        UserNameTextField.delegate = self
        PasswordTextField.delegate = self
        // call the 'keyboardWillShow' function when the view controller receive notification that keyboard is going   // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
      
          // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        dbHelper = DatabaseHelper()
        
        UserNameTextField.clipsToBounds = true
        PasswordTextField.clipsToBounds = true
        UserNameTextField.layer.cornerRadius = 10
        PasswordTextField.layer.cornerRadius = 10
        
            // view.setGradientBackground(colorOne: Theme.gradientColor1, colorTwo: Theme.gradientColor2)
        
        //        UserNameTextField.setUnderLine()
        UserNameTextField.setLeftPadding(iconName: "Email")
        //        PasswordTextField.setUnderLine()
        PasswordTextField.setLeftPadding(iconName: "Password")
        UserNameTextField.customePlaceHolder(text: "Enter Your Email", color: UIColor.white.withAlphaComponent(1))
        PasswordTextField.customePlaceHolder(text: "Enter Your Password", color: UIColor.white.withAlphaComponent(1))
        
        signInButton.layer.cornerRadius = 10
        signInButton.loginButton()
        
        
        
        // to dismiss keyboard on tap out side
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        
        
        
    }
    
  
    
    // to dismiss keyboard on tap out side
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        UserNameTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
        
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {

          // if keyboard size is not available for some reason, dont do anything
          return
        }

        var shouldMoveViewUp = false

        // if active text field is not nil
        if let activeTextField = activeTextField {

            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
          
          let topOfKeyboard = self.view.frame.height - keyboardSize.height

          // if the bottom of Textfield is below the top of keyboard, move up
          if bottomOfTextField > topOfKeyboard {
            shouldMoveViewUp = true
          }
        }

        if(shouldMoveViewUp) {
          self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
    }
    
    @IBAction func signuPBtn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "signup") as! SignUpViewController
        self.present(vc, animated: true, completion: nil)
      
        
    }
    override func viewDidAppear(_ animated: Bool) {
        dbHelper = DatabaseHelper()
        firebaseHelper = FirebaseHelper()
        
        userObjectPass = dbHelper.checkLoggedIn()
        
        
        if (userObjectPass != nil){

            performSegue(withIdentifier: "MainTabbedBar", sender: self)
        }
        
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        
        view.endEditing(true)
        
        
        var email = UserNameTextField.text!
        email = email.lowercased()
        
        let userDataFromFirebase = firebaseHelper.getUserFromFirebase(userEmail: email)
        
        let password = PasswordTextField.text!
        
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
  // when user select a textfield, this method will be called
  func textFieldDidBeginEditing(_ textField: UITextField) {
    // set the activeTextField to the selected textfield
    self.activeTextField = textField
  }
    
  // when user click 'done' or dismiss the keyboard
  func textFieldDidEndEditing(_ textField: UITextField) {
    self.activeTextField = nil
  }
}
