import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet var containerView: UIView!
    
    var practiceName = ""
    var index = 0
    var remindPractice = PracticeReminder()
    override func awakeFromNib() {
        super.awakeFromNib()
        Utilities.addBorderToView(containerView)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  }
