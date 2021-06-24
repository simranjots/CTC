import UIKit

class HomeVCCell: UITableViewCell {

    // variables
    
    var dbHelper: DatabaseHelper!
    var userPracticesData: UserPracticesData!
    var resultFlag: Int!
    var practice: Practice!
    var selectedDate: Date!
    var view: UIView!
    var isOn: Bool = false
    var userObject: User!
    
    @IBOutlet var homeScreenTableCellView: UIView!
    @IBOutlet var activityImageView: UIImageView!
    @IBOutlet var activityNameLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var tagLineLabel: UILabel!
    @IBOutlet var starButtonOutlet: UIButton!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        dbHelper = DatabaseHelper()
        userPracticesData = UserPracticesData()
        
        homeScreenTableCellView.layer.cornerRadius = homeScreenTableCellView.frame.height / 7
//        homeScreenTableCellView.layer.borderColor = #colorLiteral(red: 0.4509803922, green: 0.4509803922, blue: 0.4509803922, alpha: 1)
//        homeScreenTableCellView.layer.borderWidth = 1
//        
        homeScreenTableCellView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        homeScreenTableCellView.layer.shadowOpacity = 0.5
        homeScreenTableCellView.layer.shadowOffset = CGSize(width: 0.0, height: 1.7)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func toggleStarTapped(_ sender: UIButton) {
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
            starButtonOutlet.setImage(UIImage(named: "Star-Selected"), for: .normal)
         
        }else{
            
            starButtonOutlet.setImage(UIImage(named: "Star"), for: .normal)
         
        }
    }
}
