

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate {

    
    var dbHelper: DatabaseHelper!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var backToSignIn: UIButton!
    
   
    var activeField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    
        registerForKeyboardNotifications()
       dbHelper = DatabaseHelper()
        
        // to make text field round corner
        // view.setGradientBackground(colorOne: Theme.gradientColor1, colorTwo: Theme.gradientColor2)
        nameTextField.clipsToBounds = true
        passwordTextField.clipsToBounds = true
        emailTextField.clipsToBounds = true
        nameTextField.layer.cornerRadius = 10
        emailTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
        
        
        nameTextField.customePlaceHolder(text: "Enter Your Name", color: UIColor.white.withAlphaComponent(1))
        emailTextField.customePlaceHolder(text: "Enter Your Email", color: UIColor.white.withAlphaComponent(1))
        passwordTextField.customePlaceHolder(text: "Enter Your Password", color: UIColor.white.withAlphaComponent(1))
        
        nameTextField.setLeftPadding(iconName: "Name")
        emailTextField.setLeftPadding(iconName: "Email")
        passwordTextField.setLeftPadding(iconName: "Password")
        
        createAccountButton.layer.cornerRadius = 10
        
        createAccountButton.loginButton()

       
        
        
        // to dismiss keyboard on tap out side
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        

        // Do any additional setup after loading the view.
    }
    
    // to dismiss keyboard on tap out side
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
    }
    @IBAction func backtoSignIn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
 
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        
        
        
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
                        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "moreToLoginOptions") as! LoginViewController
                        self.present(vc, animated: true, completion: nil)
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
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollview.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)

        self.scrollview.contentInset = contentInsets
        self.scrollview.scrollIndicatorInsets = contentInsets

        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollview.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }

    @objc func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        self.scrollview.contentInset = contentInsets
        self.scrollview.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollview.isScrollEnabled = false
    }

    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
    
    
}
