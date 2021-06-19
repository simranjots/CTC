import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
    
    }
  
}
