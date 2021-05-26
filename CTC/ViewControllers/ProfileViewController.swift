
import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dbHelper : DatabaseHelper!
    var userObject : User!
    var userData: [String: String]!
    
    var datePicker: UIDatePicker!
   
    
    let keys = [["","Name", "DOB", "Email", "Password",""],["","Card No","Card Holder Name","Card CVV",""]]
    
    
    var date:[[String:String]] = [
        [
            "Name":"Nirav",
            "DOB": "09-07-1995",
            "Email" : "niravbavishi007@gmail.com",
            "Password" : "xxxxxxxxxx"
        ],

        
    ]
    
    @IBOutlet weak var profileDataTableView: UITableView!
    // popup view outlets
    
    @IBOutlet var popUpView: UIView!
    @IBOutlet weak var popUpForegroundView: UIView!
    @IBOutlet weak var popUpBackgroundView: UIView!
    @IBOutlet weak var popUpTitleLsbel: UILabel!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    //// popup view outlets
    
    
    //first profile view
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var emailTextLabel: UILabel!
    @IBOutlet weak var addressTextLabel: UILabel!
    @IBOutlet weak var personalInfoLabel: UILabel!
    @IBOutlet weak var viewBavkView: UIView!
    
//// first  profile view
    
    //second card info
    
    
    @IBOutlet weak var cardInfoTitleLabel: UILabel!
    @IBOutlet weak var cardInfoForegroundView: UIView!
    @IBOutlet weak var cardInfoBackgroundView: UIView!
    @IBOutlet weak var cardNameTextLabel: UILabel!
    @IBOutlet weak var cardNoTextLabel: UILabel!
    @IBOutlet weak var cardCVVTextLabel: UILabel!
    
    
    
    //// second Card info
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbHelper = DatabaseHelper()
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(self.DatePickerValueChanged(datePicker:)), for: .valueChanged)
        dobTextField.inputView = datePicker
        createDoneToolBar(textField: dobTextField)
        
        userObject = dbHelper.checkLoggedIn()
        
        createDoneToolBar(textField: nameTextfield)
        createDoneToolBar(textField: dobTextField)
        createDoneToolBar(textField: passwordTextfield)
        popUpForegroundView.setPopupView()
        updateButton.setPopUpButton()
        cancelButton.setPopUpButton()
        popUpTitleLsbel.setPopUpTitle()
    
        
        // bar button
        
        let barButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(self.editButtonTapped))
        
        navigationItem.rightBarButtonItem = barButton
        
        userData = (["Name": userObject.name, "Email": userObject.email, "Password": userObject.password,"DOB": userObject.dob ?? ""] as! [String : String])
        
        
    }
    
    @objc func DatePickerValueChanged(datePicker: UIDatePicker){
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MMM-yyyy"
        dobTextField.text = dateformatter.string(from: datePicker.date)
        
    }
    
    @objc func editButtonTapped() {
        
        let alert = UIAlertController(title: "Confirm Password", message: "Enter Your Current Password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action:UIAlertAction) -> Void in
            self.showPopUp(password: alert.textFields![0].text!)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter Your Current Password"
        }
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func showPopUp(password: String) {
        
        if dbHelper.passwordCheck(email: userObject.email!, password: password){
            
            nameTextfield.text = userObject.name
            emailTextfield.text = userObject.email
            
//            var pas = ""
//            let no = (userObject.password)?.count
//            for _ in 1 ... no!{ pas += "*" }
//                passwordTextfield.text = pas
            passwordTextfield.text = userObject.password
            dobTextField.text = userObject.dob
            
            self.view.addSubview(popUpView)
            popUpView.center = self.view.center
            
        }
        
    }
    
    func refreshTableView() {
        
        userObject = dbHelper.checkLoggedIn()
        userData = (["Name": userObject.name, "Email": userObject.email, "Password": userObject.password, "DOB": userObject.dob] as! [String : String])
        self.profileDataTableView.reloadData()
        
        
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        
        let resultFlag = dbHelper.updateUser(oldEmail: userObject.email!, newEmail: emailTextfield.text!, name: nameTextfield.text!, dob: dobTextField.text!, password: passwordTextfield.text!)
        if resultFlag == 0{
            
            self.popUpView.removeFromSuperview()
            nameTextfield.text = ""
            passwordTextfield.text = ""
            dobTextField.text = ""
            emailTextfield.text = ""
            showToast(message: "Profile Updated", duration: 3.0)
            refreshTableView()
            
            
        }else{
            
            self.popUpView.removeFromSuperview()
            showToast(message: "Updation Fail. . .", duration: 3.0)
            
        }
        
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.popUpView.removeFromSuperview()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return date.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileHeader") as! ProfileHeaderCell
        
        if section == 0{
        
            cell.headerLabel.text = "Personal Information"
            cell.headerLabel.textColor = Theme.grey
            cell.backgroundColor = Theme.greenishBlue
            
        }else if section == 1{
            
            cell.headerLabel.text = "Card Information"
            
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return date[section].count + 2
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileData") as? ProfileDataTableViewCell
        
        if indexPath.row == keys[indexPath.section].endIndex || indexPath.row == keys[indexPath.section].startIndex {
        
            cell?.titleLabel.text = nil
            cell?.contentTextLabel.text = nil
            
        }else{
            let key = keys[indexPath.section][indexPath.row]
            if(indexPath.section == 0 && indexPath.row != keys[indexPath.section].endIndex){
                
                cell?.titleLabel.text = key
                var pas = ""
                if(key == "Password"){
                    for _ in userData![key]!{
                        pas += "*"
                    }
                    cell?.contentTextLabel.text = pas
                }else{
                cell?.contentTextLabel.text = userData[key]
                }
                
            }else{

            }
            
            
        }
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.awakeFromNib()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    

}

extension UILabel{
    
    func setLabelView(){
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        view.backgroundColor = UIColor.blue
        
        
        self.addSubview(view)
        
    }
    
    func makeTitleLabel(){
        
        self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        self.layer.backgroundColor = UIColor(displayP3Red: 41/255, green: 100/255, blue: 188/255, alpha: 1).cgColor
        
    }
    
    func setUnderLine(){
        
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 0
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.cornerRadius = 2
        
    }
    
}
