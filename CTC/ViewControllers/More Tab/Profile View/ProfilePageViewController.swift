
import UIKit
import MobileCoreServices
import Firebase



class ProfilePageViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var updateProfileButton: UIButton!
    var user : CurrentUser!
    var userObject: User!
    var email = ""
    var Password = ""
    var isIconClicked = true
   
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleElements()
        user = CurrentUser()
        userObject = user.checkLoggedIn()
       
        setUpData()
        
    }
    
    
    //MARK: - Stylling
    func styleElements() {
        
        //Style textFiels and button
        Utilities.addBottomLineToTextField(nameTextField)
        Utilities.addBottomLineToTextField(emailTextField)
        Utilities.addBottomLineToTextField(passwordTextField)
        Utilities.styleButton(updateProfileButton)
        
        //Style profile Image
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        Utilities.addBorderToView(profileImageView)
        
    }
    
    func setUpData() {
        guard let passwordRightIcon = UIImage(named: "openEye") else { return }
        addPasswordEyeIcon(textField: passwordTextField, andImage: passwordRightIcon)
        nameTextField.text = userObject.name
        emailTextField.text = userObject.email
        passwordTextField.text = userObject.password
        email = userObject.email!
        if userObject.image != nil {
            profileImageView.image  = UIImage(data: userObject.image!)
        }
        Password = userObject.password!
   
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
    
    //MARK: - IBActions
    @IBAction func imageEditButtonTapped(_ sender: UIButton) {
        actionSheet()
    }
    
    @IBAction func updateProfileButtonTapped(_ sender: UIButton) {
        let newEmail = emailTextField.text!
        let newpassword = passwordTextField.text!
        let newName = nameTextField.text!
        let data = #imageLiteral(resourceName: "profileImage").jpegData(compressionQuality: 1.0)
        let imageData = profileImageView.image?.jpegData(compressionQuality: 1.0)
        let credential = EmailAuthProvider.credential(withEmail: email, password: Password)
        let user = Auth.auth().currentUser
        user?.reauthenticate(with: credential, completion: { Result, Error in
            if Error !=  nil {
            }else{
//                Auth.auth().currentUser?.updateEmail(to: newEmail) { error in
//                    if error != nil {
//                        self.showAlert(title: "warning", message: "The email address is already in use by another account.", buttonTitle: "try again")
//                    }else{
//                        let result = self.user.updateUser(oldEmail: self.email, newEmail: newEmail, name: newName, password: newpassword, image: imageData ?? data)
//                        if result == 0 {
//                            self.showToast(message: "Successfully updated", duration: 2.0)
//                            _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
//                                self.navigationController?.popViewController(animated: true)
//                            }
//
//
//                        } else {
//
//                            self.showToast(message: "Updation Fail. . .", duration: 2.0)
//
//                        }
//                    }
//                }
                Auth.auth().currentUser?.updatePassword(to: newpassword) { error in
                    if error != nil {
                        self.showAlert(title: "warning", message: "\(String(describing: error))" , buttonTitle: "tryagain")
                    }else{
                        let result = self.user.updateUser(oldEmail: self.email, newEmail: newEmail, name: newName, password: newpassword, image: imageData ?? data)
                        if result == 0 {
                            self.showToast(message: "Successfully updated", duration: 2.0)
                            _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
                                self.navigationController?.popViewController(animated: true)
                            }
                         
                            
                        } else {
                          
                            self.showToast(message: "Updation Fail. . .", duration: 2.0)
                            
                        }
                    }
                    
                }
            }
        })
       
      
    }
    func updatefirebaseuser(Email : String , password : String) {
      
      
           
    }
    
    
    //MARK: - Helper functions
    func actionSheet() {
        
        let alert = UIAlertController(title: "Choose Image from: ", message: nil, preferredStyle: .actionSheet)
        
        //To open camera
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { (handler) in
            self.openCamera()
        }))
        
        //To open gallery
        alert.addAction(UIAlertAction(title: "Open Gallery", style: .default, handler: { (handler) in
            self.openGallery()
        }))
        
        //To Cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let image = UIImagePickerController()
            image.sourceType = .camera
            image.allowsEditing = true
            image.delegate = self
            image.mediaTypes = [kUTTypeImage as String]
            present(image, animated: true)
        }
    }
    
    func openGallery() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let image = UIImagePickerController()
            image.sourceType = .photoLibrary
            image.allowsEditing = true
            image.delegate = self
            present(image, animated: true)
        }
    }
}

//MARK: - Extension for UIImagePickerViewController

extension ProfilePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            profileImageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

