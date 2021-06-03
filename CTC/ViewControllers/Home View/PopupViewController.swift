import UIKit

class PopupViewController: UIViewController {
    
    let moreOptionIconList = ["Home", "Profile", "More"]
    var imageName: String = ""
    var dbHelper: DatabaseHelper!
    
    
    
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var resolutionTextTextField: UITextField!
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var tittleTextLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dbHelper = DatabaseHelper()
        // Do any additional setup after loading the view.
        popupView.layer.cornerRadius = 10
        popupView.layer.borderWidth = 1
        popupView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        popupView.layer.shadowColor = UIColor.darkGray.cgColor
        popupView.layer.shadowOffset = CGSize(width: 0, height: 0)
        popupView.layer.shadowRadius = 10
        popupView.layer.shadowOpacity = 1
        
        tittleTextLabel.layer.shadowOpacity = 0.5
        tittleTextLabel.layer.shadowRadius = 0
        tittleTextLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        tittleTextLabel.layer.shadowColor = UIColor.lightGray.cgColor
        tittleTextLabel.backgroundColor = UIColor.white
        
        saveButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        saveButton.layer.borderWidth = 0.5
        cancelButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        cancelButton.layer.borderWidth = 0.5
        
    }
    
 
    
    
  
    
    func changeResolutionIcon(number: Int){
        
        
        imageName = moreOptionIconList[number]
        imageButton.setImage(UIImage(named: moreOptionIconList[number]), for: .normal)
        
    }
    
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        let practice = resolutionTextTextField.text
        let image_Name = imageName
        
        if (practice != "" && image_Name != ""){
            
            
            
            let practiceFlag = 1
//                newPractice.addPractices(practice: practice!, image_name: image_Name,)
            
            if(practiceFlag == 1){
                
                showAlert(title: "Warning", message: "Practice Already Exist. . . ", buttonTitle: "Try Again")
                
            }
            else if(practiceFlag == 2){
                
                showAlert(title: "Error", message: "Please Report an Error . . .", buttonTitle: "Try Again")
                
            }else if (practiceFlag == 0 ){
                
       
                
//                dismiss(animated: true, completion: nil)
                
//                dismiss(animated: true)
//                {
////                    super.viewWillAppear(true)
////                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
//
////                      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext          let task = Task(context: context)
////                    task.label = txtLabel.text!
////                    task.isAlert = isAlert.isOn
////                    // Save to coredata
//////                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
////                    dismiss(animated: true, completion: nil)
//
//                }
            }
            
        }
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
         dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func imageButtonTapped(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "Resolution Icons", message: "Choose an Icon to Categories Your Resolution", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Home", style: .default){action in self.changeResolutionIcon(number: 0)})
        
        actionSheet.addAction(UIAlertAction(title: "Profile", style: .default){action in self.changeResolutionIcon(number: 1)})
        
        actionSheet.addAction(UIAlertAction(title: "More", style: .default){action in self.changeResolutionIcon(number: 2)})
        
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet,animated: true)
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
