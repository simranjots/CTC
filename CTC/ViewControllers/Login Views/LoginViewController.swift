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
    var userSetup = [userModel]()
    let storageRef = Storage.storage().reference()
    var database : FirebaseDataManager!
    private var rememberMeFlag = false
    //Outlets
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var gmailSignInButton: UIButton!
    @IBOutlet var facebookSignInButton: UIButton!
    @IBOutlet weak var becomeamember: UIButton!
    
    
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
        gmailSignInButton.isHidden = true
        facebookSignInButton.isHidden = true
        rememberMeFlag = UserDefaults.standard.bool(forKey: "REMEMBER_USER")
        if rememberMeFlag {
            checkbox.setImage(UIImage(named: "check"), for: .normal)
            let email = UserDefaults.standard.string(forKey: "USER_EMAIL")
            emailTextField.text = email
        }else{
            checkbox.setImage(UIImage(named: "uncheck"), for: .selected)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        gmailSignInButton.isHidden = true
        facebookSignInButton.isHidden = true
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
    
    
    @IBAction func checkboxBtn(_ sender: UIButton) {
        rememberMeFlag = !rememberMeFlag
        UserDefaults.standard.set(rememberMeFlag, forKey: "REMEMBER_USER")
        if rememberMeFlag {
            checkbox.setImage(UIImage(named: "check"), for: .normal)
            let text = emailTextField.text
            UserDefaults.standard.set(text, forKey:"USER_EMAIL")
        }else{
            checkbox.setImage(UIImage(named: "uncheck"), for: .normal)
            UserDefaults.standard.removeObject(forKey: "USER_EMAIL")
        }
    }
    
    @objc func textFieldDidChange(_ sender: UITextField){
          guard rememberMeFlag else { return }
          let text = emailTextField.text
          UserDefaults.standard.set(text, forKey:"USER_EMAIL")
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
                    Auth.auth().signIn(withEmail: email, password: password) {[weak self] (success,message) in
                        guard let self = self else { return }
                        if message != nil {
                            self.showAlert(title: "Error!", message: message!.localizedDescription, buttonTitle: "Try Again")
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                        }
                        if (success != nil) {
                        if (Auth.auth().currentUser?.isEmailVerified)! {
                            let userupdate = self.db.collection("dap_users").document(Auth.auth().currentUser!.uid)
                            userupdate.updateData([
                                "verified": "Verified"
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                }
                            }
                            if self.currentUser.checkUser(email: email) {
                                if self.currentUser.passwordCheck(email: email, password: password){
                                    let save = self.currentUser.updateLoginStatus(status: true, email: email)
                                    if save == 0 {
                                        if UserDefaults.standard.bool(forKey: "OnBoard"){
                                            self.performSegue(withIdentifier: Constants.Segues.signInToHomeSegue, sender: self)
                                            }else{
                                                UserDefaults.standard.setValue(true, forKey: "OnBoard")
                                                self.performSegue(withIdentifier: Constants.Segues.onBoardingSegue, sender: self)
                                        self.performSegue(withIdentifier: Constants.Segues.signInToHomeSegue, sender: self)
                                            }
                                    }
                                    
                                }else{
                                    let saved =  self.currentUser.updatepassword(Email: email, password: password)
                                    if saved == 0 {
                                       
                                            self.performSegue(withIdentifier: Constants.Segues.signInToHomeSegue, sender: self)
                                            
                                    }
                                }
                            }else{
                                self.database.FetchTUserData(email: email, completion: { (users) in
                                    self.userSetup = users
                                    for user in self.userSetup {
                                        
                                        if user.email == email {
                                            let fileUrl = URL(string: user.imageLink!)
                                            
                                            // Fetch Image Data
                                            if let data = try? Data(contentsOf: fileUrl!) {
                                                
                                                // Create Image and Update Image View
                                                let imagedownloaded = UIImage(data: data)
                                                let image = imagedownloaded?.jpegData(compressionQuality: 1.0)
                                                let out = self.currentUser.addUser(name: user.name!, email: email, password: password, image: image, uid: (success?.user.uid)!, from: "signIn")
                                                if(out == 0){
                                                    if UserDefaults.standard.bool(forKey: "OnBoard"){
                                                        self.performSegue(withIdentifier: Constants.Segues.signInToHomeSegue, sender: self)
                                                        }else{
                                                            UserDefaults.standard.setValue(true, forKey: "OnBoard")
                                                            self.performSegue(withIdentifier: Constants.Segues.onBoardingSegue, sender: self)
                                                    self.performSegue(withIdentifier: Constants.Segues.signInToHomeSegue, sender: self)
                                                        }
                                                   
                                                }else{
                                                    self.showAlert(title: "Login Fail", message: "Invalid Login Credentials. . .", buttonTitle: "Try Again")
                                                    self.activityIndicator.stopAnimating()
                                                    self.activityIndicator.isHidden = true
                                                }
                                            }
                                        }
                                    }
                                })
                            }
                            
                            
                        }else{
                            self.showAlert(title: "Login Fail", message: "Please verify your email. An email verification link has already sent on your email.", buttonTitle: "OK")
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                        }
                    }else{
                            self.showAlert(title: "Login Fail", message: "Please verify your email. An email verification link has already sent on your email.", buttonTitle: "OK")
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                        }
                        
                    }
                    
                    
                    
                } else {
                    showToast(message: "Enter Valid Password", duration: 2.0)
                    activityIndicator.stopAnimating()
                    activityIndicator.isHidden = true
                }
            } else {
                showToast(message: "Enter Valid Email", duration: 2.0)
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
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
        textFieldImageView.tintColor = UIColor(named: "Brand Secondary Color")
        
        //Add Tap Gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(eyeImageTapped(tapGestureRecognizer: )))
        textFieldImageView.isUserInteractionEnabled = true
        textFieldImageView.addGestureRecognizer(tapGestureRecognizer)
        
        
    }
    
    @objc func eyeImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
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
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            return "Email or password are blank."
        }
        
        //Validate Email format is correct
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isEmailValid(cleanedEmail) == false {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            return "Please enter correct email."
        }
        
        //Validate password is correct
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
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

