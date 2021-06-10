import Foundation
import UIKit
protocol PopUpProtocol {
    func handleAction(action: Bool)
}
class PopUpHome :UIViewController{
    static let identifier = "PopUpActionViewController"
    
    var delegate: PopUpProtocol?
    var userPractices: UserPractices!
    var userPracticesData: UserPracticesData!
    var currentUser : CurrentUser!
    var selectedDate: Date!
    var isUpdating: Bool! = false
    var oldPractice: String?
    var userObject: User!
    var practices:[Practice]!
    var homeViewController = HomeViewController()
    var practicesData: [PracticeData]!
    let date = Date()
    static var cvalue : String = ""
    static var cindexPath : Int = 0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dialogBoxView: UIView!
    @IBOutlet weak var resolutionField: UITextField!
    @IBOutlet weak var imagePickerButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    let moreOptionIconList = ["Book", "cheese", "dollar","excercise","flour","friendCircle","language","maditation","Music","salad","sleep","spaCandle","speak","walking","wineGlass","Yoga"]
    var imageName: String = ""
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerView.isHidden = true
        dateField.text = date.dateFormatemmmdd()
        userPractices = UserPractices()
        currentUser = CurrentUser()
        userPracticesData = UserPracticesData()
        userObject = currentUser.checkLoggedIn()
        selectedDate = Date().dateFormate()!
        practices = self.getPractices()
        practicesData = self.getPracticesData(date: selectedDate)
       
        setData(PopUpHome.cvalue, PopUpHome.cindexPath)
      
        
        
        
        
        //MARK: Popup Date Picker
        datePickerView.datePickerMode = .date
        datePickerView.addTarget(self, action: #selector(self.PopUpDatePickerValueChanged(datePicker:)), for: .valueChanged)
        dateField.inputView = datePickerView
        datePickerView.maximumDate = Date()
        
        //adding an overlay to the view to give focus to the dialog box
        view.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        //MARK: Custome Done Tool bar
              
              let toolBar = UIToolbar()
              toolBar.sizeToFit()
              let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dateSelected))
      
              toolBar.setItems([doneButton], animated: false)
              toolBar.isUserInteractionEnabled = true
              dateField.inputAccessoryView = toolBar
        
        //customizing the dialog box view
        dialogBoxView.layer.cornerRadius = 6.0
        dialogBoxView.layer.borderWidth = 1.2
        dialogBoxView.layer.borderColor = UIColor(named: "dialogBoxGray")?.cgColor
        
        //customizing the add button
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.layer.borderWidth = 1.2
        addButton.layer.cornerRadius = 4.0
        addButton.layer.borderColor = UIColor(named: "primaryBackground")?.cgColor
        
        //customizing the cancel button
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.layer.borderWidth = 1.2
        cancelButton.layer.cornerRadius = 4.0
        cancelButton.layer.borderColor = UIColor(named: "primaryBackground")?.cgColor
    }
    
    private func getPractices() -> [Practice]{
        
        
        return userPractices.getPractices(user: userObject)!
        
    }
    private func getPracticesData(date: Date) -> [PracticeData]?{
        
        
        return userPracticesData.getPracticeDataByDate(date: date.dateFormate()!)
        
    }
    
    
        @objc func dateSelected() {
            dateField.text = datePickerView.date.dateFormatemmmdd()
            self.view.endEditing(true)
    
        }
    
    @objc func PopUpDatePickerValueChanged(datePicker: UIDatePicker){
        
        dateField.text = datePicker.date.dateFormatemmmdd()!
        
    }
    
    
    @IBAction func imageButtonPressed(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Resolution Icons", message: "Choose an Icon to Categories Your Resolution", preferredStyle: .actionSheet)
        for icon in moreOptionIconList{
            let image = UIImage(named: icon)
            
            let action = UIAlertAction(title: icon, style: .default){action in self.changeResolutionIcon(imageName: icon)}
            action.setValue(image, forKey: "image")
            actionSheet.addAction(action)
            
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view //to set the source of your alert
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
        }
        
        present(actionSheet,animated: true)
    }
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        let practiceName = resolutionField.text
        let image_Name = imageName
        if (practiceName == ""){
            
            showToast(message: "Please Enter Your Practice", duration: 3)
            
        }
        else if(image_Name == ""){
            
            showToast(message: "Please Select Icon For Practice", duration: 3)
            
        }
        else if(dateField.text == ""){
            showToast(message: "Please Select Practice Starting Date", duration: 3)
        }
        else{
            var practiceFlag: Int!
            if(isUpdating){
                practiceFlag = userPractices.updatePractice(oldPractice: oldPractice!, newPractice: practiceName!, image_name: image_Name, date: datePickerView.date.dateFormate()!, user: userObject)
                isUpdating = false}
            else{
                practiceFlag = userPractices.addPractices(practice: practiceName!, image_name: image_Name, date: datePickerView.date.dateFormate()!, user: userObject)
                isUpdating = false
            }
            
            
            if(practiceFlag == 1){
                
                showAlert(title: "Warning", message: "Practice Already Exist. . . ", buttonTitle: "Try Again")
                
            }
            else if(practiceFlag == 2){
                
                showAlert(title: "Error", message: "Please Report an Error . . .", buttonTitle: "Try Again")
                
            }else if (practiceFlag == 0 ){
                
                self.resolutionField.text = ""
                self.imageName = ""
                self.datePickerView.date = Date()
                self.imagePickerButton.setImage(UIImage(named: "Image-gallery"), for: .normal)
                self.dialogBoxView.removeFromSuperview()
                let storyboard = UIStoryboard(name: "TabVC", bundle: nil)
                let home = storyboard.instantiateViewController(withIdentifier: "MainTabbedBar")
                present(home, animated: true)
            }
            
        }
        
        
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.resolutionField.text = ""
        self.imageName = ""
        self.datePickerView.date = Date()
        self.imagePickerButton.setImage(UIImage(named: "Iphoto.on.rectangle.angled"), for: .normal)
        self.dialogBoxView.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)
    }
 
    
    @IBAction func dateFieldTapped(_ sender: Any) {
        datePickerView.isHidden = false
    }
    
    
    func changeResolutionIcon(imageName: String){
        
        self.imageName = imageName
        imagePickerButton.setImage(UIImage(named: imageName), for: .normal)
        
    }
    
    func setData(_ value : String,_ indexPath: Int){
        if value == "add" {
            add()
        }
        if value == "edit" {
            update(indexPath: indexPath)
        }
    }
    
    func add(){
        self.titleLabel.text = "Add Practice"
        self.addButton.setTitle("Add", for: .normal)
        dateField.text = Date().dateFormatemmmdd()
        
    }
    func update(indexPath :Int) {
        resolutionField.text = self.practices[indexPath].practice
        oldPractice = self.practices[indexPath].practice
        
        imagePickerButton.setImage(UIImage(named: self.practices[ indexPath].image_name!), for: .normal)
        
         imageName = self.practices[indexPath].image_name!
        
        datePickerView.date = (self.practices[indexPath].startedday)! as Date
        
        dateField.text = ((self.practices[indexPath].startedday)! as Date).dateFormatemmmdd()
        titleLabel.text = "Edit Practice"
        addButton.setTitle("Confirm", for: .normal)
        isUpdating = true
    }
    
    //MARK:- functions for the viewController
     func showPopup(parentVC: UIViewController,value : String,indexpath :Int){
        PopUpHome.cvalue = value
        PopUpHome.cindexPath = indexpath
        //creating a reference for the dialogView controller
        if let popupViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "PopUpActionViewController") as? PopUpHome {
            popupViewController.modalPresentationStyle = .custom
            popupViewController.modalTransitionStyle = .crossDissolve
            
            //setting the delegate of the dialog box to the parent viewController
            popupViewController.delegate = parentVC as? PopUpProtocol
            //presenting the pop up viewController from the parent viewController
            parentVC.present(popupViewController, animated: true)
        }
    }
}

