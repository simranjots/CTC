import UIKit

class LoginViewController: UIViewController {
    
    
    //Dabase initilizers
    var currentUser : CurrentUser!
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
       currentUser = CurrentUser()
        setUpElements()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
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
        Utilities.styleGmailButton(gmailSignInButton)
        Utilities.styleFacebookButton(facebookSignInButton)
        
        //Set textField Images
        Utilities.addTextFieldImage(textField: emailTextField, andImage: emailTextFieldImage)
        Utilities.addTextFieldImage(textField: passwordTextField, andImage: passwordTextFieldImage)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
       currentUser = CurrentUser()
       firebaseHelper = FirebaseHelper()
       userObjectPass = currentUser.checkLoggedIn()
        if (userObjectPass != nil){

            performSegue(withIdentifier: "MainTabbedBar", sender: self)
        }
        
    }
    
    
    @IBAction func signInButtonTapped(_ sender: Any) {
       view.endEditing(true)
     var email = emailTextField.text!
        email = email.lowercased()
       let password = passwordTextField.text!
        
        if(email.isValidEmail){
            
            if(password.isValidPassword){
                
                let result = currentUser.signInUser(email, password)
                
                if result {
                   performSegue(withIdentifier: "MainTabbedBar", sender: self)
                }
                else {
                    
                    showAlert(title: "Login Fail", message: "Invalid Login Credentials. . .", buttonTitle: "Try Again")
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
