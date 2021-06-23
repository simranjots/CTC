import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var timeField: UITextField!

    var practiceName = ""
    var index = 0
    var remindPractice = PracticeReminder()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
 
  }
