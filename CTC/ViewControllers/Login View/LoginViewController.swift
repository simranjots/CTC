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
    
    var isIconClicked = true
    
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
        guard let emailIcon = UIImage(named: "email") else { return }
        guard let passwordLeftIcon = UIImage(named: "password") else { return }
        guard let passwordRightIcon = UIImage(named: "closedEye") else { return }
        
        //Style the textFields
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        //Style the buttons
        Utilities.styleButton(signInButton)
        Utilities.styleGmailButton(gmailSignInButton)
        Utilities.styleFacebookButton(facebookSignInButton)
        
        //Set textField Images
        Utilities.addTextFieldImage(textField: emailTextField, andImage: emailIcon)
        Utilities.addTextFieldImage(textField: passwordTextField, andImage: passwordLeftIcon)
        addPasswordEyeIcon(textField: passwordTextField, andImage: passwordRightIcon)
        
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
    
    func addPasswordEyeIcon(textField: UITextField, andImage image: UIImage) {
        
        //Create textField view
        let textFieldRightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        //Create textField subview and add image
        let textFieldImageView = UIImageView(image: image)
        
        //Set subview frame
        textFieldImageView.frame = CGRect(x: 0, y: 8, width: 25, height: 25)
        
        //Add subview
        textFieldRightView.addSubview(textFieldImageView)
        
        //Set leftside textField properties
        textField.rightView = textFieldRightView
        textField.rightViewMode = .always
        
       
        //Add color to textField Image
        textFieldImageView.tintColor = .darkGray
        
        //Add Tap Gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer: )))
        textFieldImageView.isUserInteractionEnabled = true
        textFieldImageView.addGestureRecognizer(tapGestureRecognizer)
        
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let tappedImage = tapGestureRecognizer.view as! UIImageView
         
        if isIconClicked {
            isIconClicked = false
            tappedImage.image = UIImage(named: "openEye")
            passwordTextField.isSecureTextEntry = false
            
        } else {
            isIconClicked = true
            tappedImage.image = UIImage(named: "closedEye")
            passwordTextField.isSecureTextEntry = true
        }
        
    }
    
    
}