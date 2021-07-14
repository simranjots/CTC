

import UIKit
import Firebase

class SignUpViewController: UIViewController,UITextFieldDelegate {
    
    
    var dbHelper: DatabaseHelper!
    var currentUser : CurrentUser!
    let db = Firestore.firestore()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var isIconClicked = true
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    //var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = CurrentUser()
        setUpElements()
        
    }
    
    //Set the properties of Sign Up screen elements
    func setUpElements() {
        
        //Add textField images
        guard let nameTextFieldImage = UIImage(named: "Profile") else { return }
        guard let emailTextFieldImage = UIImage(named: "Email") else { return }
        guard let passwordLeftIcon = UIImage(named: "Password") else { return }
        guard let passwordRightIcon = UIImage(named: "openEye") else { return }
        
        //Style Texfields
        Utilities.styleTextField(nameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        //Style Sign Up button
        Utilities.styleButton(signUpButton)
        //Utilities.addShadowToButton(signUpButton)
        
        //Set textField Images
        Utilities.addTextFieldImage(textField: nameTextField, andImage: nameTextFieldImage)
        Utilities.addTextFieldImage(textField: emailTextField, andImage: emailTextFieldImage)
        Utilities.addTextFieldImage(textField: passwordTextField, andImage: passwordLeftIcon)
        addPasswordEyeIcon(textField: passwordTextField, andImage: passwordRightIcon)
        
        
    }
    
    //Check the fields and validate that the data is correct. If everything is correct, this method returns
    // nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        
        //Check that all the fields are filled
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill all the fields."
        }
        
        //Check email format is valid
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isEmailValid(cleanedEmail) == false {
            return "Please make sure you have entered valid email format."
        }
        
        //Check password is secured
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 charactors, contains at least one upper case letter, a special charactor and a number."
        }
        return nil
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil {
            
            showAlert(title: "Warning!", message: error! , buttonTitle: "Try Again")
            
        } else {
            
            let userName = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            var email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            email = email.lowercased()
            
            if(!userName.isEmpty && !email.isEmpty && !password.isEmpty){
                
                if(email.isValidEmail){
                    if(password.isValidPassword){
                        //Create the user
                        Auth.auth().createUser(withEmail: email, password: password) { result, err in
                            if err != nil {
                                //There was an error creating the user
                                self.showAlert(title: "Error!", message: err!.localizedDescription , buttonTitle: "Try Again")
                            } else {
                                
                                
                                DispatchQueue.global().async {
                                    let imagepath = "https://firebasestorage.googleapis.com/v0/b/dayachievementprinciple.appspot.com/o/Profile%2FprofileImage1-2.png?alt=media&token=58f52b23-2cf9-4558-81b0-3d8c9545622d"
                                    let fileUrl = URL(string: imagepath)
                                    // Fetch Image Data
                                    if let data = try? Data(contentsOf: fileUrl!) {
                                        DispatchQueue.main.async {
                                            // Create Image and Update Image View
                                            let imagedownloaded = UIImage(data: data)
                                            let image = imagedownloaded?.jpegData(compressionQuality: 1.0)
                                            let flag = self.currentUser.addUser(name: userName, email: email, password: password, image: image, uid: Auth.auth().currentUser!.uid, from: "signUp")
                                            if(flag == 1){
                                                
                                                self.showAlert(title: "Warning", message: "User Already Exist", buttonTitle: "Try Again")
                                                
                                                
                                            }else if (flag == 2){
                                                
                                                self.showAlert(title: "Error", message: "Please Report an error. . .", buttonTitle: "Try Again")
                                                
                                            }else if (flag == 0){
                                                
                                                self.db.collection("dap_users").document(Auth.auth().currentUser!.uid)
                                                    .setData(["uid":Auth.auth().currentUser!.uid,
                                                              "name": userName,
                                                              "email":email,
                                                              "imageLink":imagepath,
                                                              "verified":"Not Verified"]) { error in
                                                        if error != nil {
                                                            self.showAlert(title: "Error!", message: error!.localizedDescription , buttonTitle: "Try Again")
                                                        }
                                                    }
                                                if Auth.auth().currentUser != nil && Auth.auth().currentUser!.isEmailVerified {
                                                    self.showAlert(title: "Error!", message: err!.localizedDescription , buttonTitle: "Try Again")
                                                    }
                                                    else {
                                                        Auth.auth().currentUser!.sendEmailVerification(completion: { (error) in
                                                            if error != nil {
                                                                self.showAlert(title: "Error!", message: error!.localizedDescription , buttonTitle: "Try Again")
                                                            }
                                                                // Notify the user that the mail has sent or couldn't because of an error.
                                                            
                                                        let alert = UIAlertController(title: "Email Sent", message: "An email verification link has been sent to your email. Please check your email.", preferredStyle: .alert)
                                                              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) -> Void in
                                                                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                                                                let vc = storyboard.instantiateViewController(withIdentifier: "LoginScreen") as! LoginViewController
                                                                self.present(vc, animated: true, completion: nil)
                                                              }))
                                                      
                                                            
                                                        self.present(alert, animated: true, completion: nil)
                                                            })
                                                    
                                                       
                                                        
                                                    }
                                            }
                                        }
                                    }
                                }
                                
                                
                                
                            }
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
    
}
