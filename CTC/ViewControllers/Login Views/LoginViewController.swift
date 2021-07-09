import UIKit
import Firebase
import FirebaseStorage
//import GoogleSignIn
//import FBSDKLoginKit
//import FBSDKCoreKit

class LoginViewController: UIViewController {
    
    
    //Dabase initilizers
    var currentUser : CurrentUser!
    var userObjectPass: User!
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    var database : FirebaseDataManager!
    //Outlets
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var gmailSignInButton: UIButton!
    @IBOutlet var facebookSignInButton: UIButton!
   
    
    // to store the current active textfield
    var activeTextField : UITextField? = nil
    var isIconClicked = true
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance().delegate = self
        database = FirebaseDataManager()
        currentUser = CurrentUser()
        setUpElements()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    

    override func viewDidAppear(_ animated: Bool) {
        
        currentUser = CurrentUser()
       
        
        userObjectPass = currentUser.checkLoggedIn()
        if (userObjectPass != nil){
            performSegue(withIdentifier: Constants.Segues.signInToHomeSegue, sender: self)
        }
    }
    
    
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        view.endEditing(true)
        
        activityIndicator.startAnimating()
        
        let error = validateFields()
        
        if error != nil {
            
            showToast(message: error!, duration: 2.0)
            
        } else {
           
            var email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            email = email.lowercased()
            if(email.isValidEmail) {
                if(password.isValidPassword) {
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        if error != nil {
                            self.showAlert(title: "Error!", message: error!.localizedDescription, buttonTitle: "Try Again")
                        } else {
                            if self.currentUser.checkUser(email: email) {
                                if self.currentUser.passwordCheck(email: email, password: password){
                                    let save = self.currentUser.updateLoginStatus(status: true, email: email)
                                    if save == 0 {
                                        self.performSegue(withIdentifier: Constants.Segues.signInToHomeSegue, sender: self)
                                    }
                                    
                                }else{
                                   let saved =  self.currentUser.updatepassword(Email: email, password: password)
                                    if saved == 0 {
                                        self.performSegue(withIdentifier: Constants.Segues.signInToHomeSegue, sender: self)
                                    }
                                }
                            }else{
                                self.database.fetchUserData(email: Auth.auth().currentUser!.email!) { flag, imagepath,name  in
                                    if flag == true {
                                        let fileUrl = URL(string: imagepath)
                                        DispatchQueue.global().async {
                                                // Fetch Image Data
                                            if let data = try? Data(contentsOf: fileUrl!) {
                                                    DispatchQueue.main.async {
                                                        // Create Image and Update Image View
                                                        let imagedownloaded = UIImage(data: data)
                                                        let image = imagedownloaded?.jpegData(compressionQuality: 1.0)
                                                      
                                                        self.currentUser.addUser(name: name, email: Auth.auth().currentUser!.email!, password: password, image: image, uid: Auth.auth().currentUser!.uid, from: "signIn", completionHandler: {(flag) -> Void in
                                                                if(flag == 0){
                                                                    var initialViewController:UIViewController?
                                                                    let storyboard = UIStoryboard(name: "TabVC", bundle: nil)
                                                                    initialViewController = storyboard.instantiateViewController(withIdentifier: "MainTabbedBar")
                                                                }else{
                                                                    self.showAlert(title: "Login Fail", message: "Invalid Login Credentials. . .", buttonTitle: "Try Again")
                                                                }
                                                            
                                                        })
                                                    }
                                                }
                                            }
                                    }
                                    
                                }
                                   
                                  
                                }
                                
                            }
                          
                         
                           
                        }
                 
                } else {
                    showToast(message: "Enter Valid Password", duration: 2.0)
                }
            } else {
                showToast(message: "Enter Valid Email", duration: 2.0)
            }
        }
    }
    
    
    @IBAction func gmailSignInButtonTapped(_ sender: UIButton) {
       // GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func faceBookSignInButtonTapped(_ sender: UIButton) {
//        let loginManager = LoginManager()
//                loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
//                    if let error = error {
//                        print("Failed to login: \(error.localizedDescription)")
//                        return
//                    }
//
//                    guard let accessToken = AccessToken.current else {
//                        print("Failed to get access token")
//                        return
//                    }
//
//                    let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
//
//                    // Perform login by calling Firebase APIs
//                    Auth.auth().signIn(with: credential, completion: { (user, error) in
//                        if let error = error {
//                            print("Login error: \(error.localizedDescription)")
//                            let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
//                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                            alertController.addAction(okayAction)
//                            self.present(alertController, animated: true, completion: nil)
//                            return
//                        }else {
//                            let currentUser = Auth.auth().currentUser
//                            self.currentUser.addUser(name: currentUser?.displayName ?? "No userName", email: (currentUser?.email)!, password: "", from: "GsignIn", completionHandler: {(flag) -> Void in
//                                if flag == 0
//                                {self.db.collection("dap_users").document((currentUser?.email)!).setData(["username": currentUser?.displayName ?? "No userName", "uid": (currentUser?.email)!]) { error in
//                                    if error != nil {
//                                        self.showAlert(title: "Error!", message: error!.localizedDescription , buttonTitle: "Try Again")
//                                    }
//                                }
//                                    print("Login Successful.")
//                                    self.performSegue(withIdentifier: Constants.Segues.signInToHomeSegue, sender: self)
//                                }else{
//                                    self.showAlert(title: "Login Fail", message: "Invalid Login Credentials. . .", buttonTitle: "Try Again")
//                                }
//
//                            })
//                        }
//
//                    })
//
//                }

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
            tappedImage.image = UIImage(named: "closedEye")
            passwordTextField.isSecureTextEntry = false
            
        } else {
            isIconClicked = true
            tappedImage.image = UIImage(named: "openEye")
            passwordTextField.isSecureTextEntry = true
        }
        
    }
    //Set the properties of login screen elements
    func setUpElements() {
        
        //Add textField Images
        guard let emailIcon = UIImage(named: "Email") else { return }
        guard let passwordLeftIcon = UIImage(named: "Password") else { return }
        guard let passwordRightIcon = UIImage(named: "openEye") else { return }
        guard let googleIcon = UIImage(named: "google") else { return }
        guard let facebookIcon = UIImage(named: "facebook") else { return }
        
        //Style the textFields
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        //Style the buttons
        Utilities.styleButton(signInButton)
        //Utilities.addShadowToButton(signInButton)
        Utilities.styleGmailButton(gmailSignInButton)
        //Utilities.addShadowToButton(gmailSignInButton)
        Utilities.styleFacebookButton(facebookSignInButton)
        //Utilities.addShadowToButton(facebookSignInButton)
        
        //Set textField Images
        Utilities.addTextFieldImage(textField: emailTextField, andImage: emailIcon)
        Utilities.addTextFieldImage(textField: passwordTextField, andImage: passwordLeftIcon)
        addPasswordEyeIcon(textField: passwordTextField, andImage: passwordRightIcon)
        Utilities.addGoogleImage(button: gmailSignInButton, andImage: googleIcon)
        Utilities.addButtonImage(button: facebookSignInButton, andImage: facebookIcon)
        
        //Hide activity indicator
        activityIndicator.hidesWhenStopped = true
        

    }
    
    func validateFields() -> String? {
        
        //Validate any field is not blank
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Email or password are blank."
        }
        
        //Validate Email format is correct
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isEmailValid(cleanedEmail) == false {
            
            return "Please enter correct email."
        }
        
        //Validate password is correct
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            return "Please enter correct password."
        }
        
        return nil
    }
   
}
//extension LoginViewController : GIDSignInDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let error = error {
//        print(error.localizedDescription)
//        return
//        }
//        guard let auth = user.authentication else { return }
//        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
//        Auth.auth().signIn(with: credentials) { (authResult, error) in
//            if let error = error {
//            print(error.localizedDescription)
//            } else {
//                let currentUser = Auth.auth().currentUser
//
//                self.currentUser.addUser(name: currentUser?.displayName ?? "No userName", email: (currentUser?.email)!, password: "", from: "GsignIn", completionHandler: {(flag) -> Void in
//                    if flag == 0
//                    {self.db.collection("dap_users").document((currentUser?.email)!).setData(["username": currentUser?.displayName ?? "No userName", "uid": (currentUser?.email)!]) { error in
//                        if error != nil {
//                            self.showAlert(title: "Error!", message: error!.localizedDescription , buttonTitle: "Try Again")
//                        }
//                    }
//                        print("Login Successful.")
//                        self.performSegue(withIdentifier: Constants.Segues.signInToHomeSegue, sender: self)
//                    }else{
//                        self.showAlert(title: "Login Fail", message: "Invalid Login Credentials. . .", buttonTitle: "Try Again")
//                    }
//
//                })
//
//
//            }
//
//        }
//    }
//
//}

