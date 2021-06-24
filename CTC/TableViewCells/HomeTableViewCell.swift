import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var practiceTextLabel: UILabel!
    @IBOutlet weak var practiceIconImage: UIImageView!

    
    @IBOutlet weak var starButton: UIButton!
    
    
    
    
    // variables
    
    var dbHelper: DatabaseHelper!
    var userPracticesData: UserPracticesData!
    var resultFlag: Int!
    var practice: Practice!
    var selectedDate: Date!
    var view: UIView!
    var isOn: Bool = false
    var userObject: User!
    // variables
    

    override func awakeFromNib() {
        super.awakeFromNib()
     self.backgroundColor = UIColor.white
        
        dbHelper = DatabaseHelper()
        userPracticesData = UserPracticesData()
    }
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
 
    @IBAction func starButtonTapped(_ sender: Any) {
        
        self.activeButton(flag: !isOn)
        resultFlag = userPracticesData.practicedToday(toggleBtn: isOn, practiceObject: practice, currentDate: selectedDate, userObject: userObject, note: "", save: "")
       
        if resultFlag == 0{
            
            print("Data Saved")
            
        }else if resultFlag == 1{
            print("error in Cell Data Saving")
            
        }

    }
    
    func activeButton(flag: Bool){
        
        isOn = flag
        
        if(isOn){
            starButton.setImage(UIImage(named: "Star-Selected"), for: .normal)
         
        }else{
            
            starButton.setImage(UIImage(named: "Star"), for: .normal)
         
        }
    }
    
    
}
