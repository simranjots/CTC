

import UIKit
import Firebase

class SignUpViewController: UIViewController,UITextFieldDelegate {

    
    var dbHelper: DatabaseHelper!
    var currentUser : CurrentUser!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    

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
        guard let nameTextFieldImage = UIImage(named: "profile") else { return }
        guard let emailTextFieldImage = UIImage(named: "email") else { return }
        guard let passwordTextFieldImage = UIImage(named: "password") else { return }
        
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
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create the user
             Auth.auth().createUser(withEmail: email, password: password) { result, err in
                if err != nil {
                    //There was an error creating the user
                    self.showAlert(title: "Error!", message: err!.localizedDescription , buttonTitle: "Try Again")
                } else {
                    
                    let resultFlag = self.currentUser.addUser(name: userName, email: email, password: password)
                    let db = Firestore.firestore()
                    db.collection("dap_users").addDocument(data: ["username": userName, "uid": result!.user.uid]) { error in
                        if error != nil {
                            self.showAlert(title: "Error!", message: error!.localizedDescription , buttonTitle: "Try Again")
                        } else if resultFlag == 1 {
                            self.showAlert(title: "Warning", message: "User Already Exist", buttonTitle: "Try Again")
                            //self.performSegue(withIdentifier: Constants.Segues.signUpToHomeSegue, sender: self)
                        }
                    }
                    //Trasition to the Home screen
                    self.performSegue(withIdentifier: Constants.Segues.signUpToHomeSegue, sender: self)
                }
            }
        }
        
//        let name = nameTextField.text!
//        var email = emailTextField.text!
//        email = email.lowercased()
//        let password = passwordTextField.text!
//
//        if(!name.isEmpty && !email.isEmpty && !password.isEmpty){
//
//            if(email.isValidEmail){
//                if(password.isValidPassword){
//
//                    let resultFlag = currentUser.addUser(name: name, email: email, password: password)
//                    let fireRef = FirebaseHelper()
//                    fireRef.addUser(userName: name, userEmail: email, userPassword: password)
//
//                    if(resultFlag == 1){
//
//                        showAlert(title: "Warning", message: "User Already Exist", buttonTitle: "Try Again")
//
//
//                    }else if (resultFlag == 2){
//
//                        showAlert(title: "Error", message: "Please Report an error. . .", buttonTitle: "Try Again")
//
//                    }else if (resultFlag == 0){
//
//                        performSegue(withIdentifier: "MainTabbedBar", sender: self)
//                    }
//
//                }else{
//                    showToast(message: "Enter Valid Password", duration: 2.0)
//                }
//            }else{
//                showToast(message: "Enter Valid Email", duration: 2.0)
//            }
//
//
////        }
//        else{
//
//            print("fill the form")
//
//        }
//
    }
  
}
