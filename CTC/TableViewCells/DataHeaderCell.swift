import UIKit

class DataHeaderCell: UITableViewCell {
    
    
    @IBOutlet weak var LabelDate: UILabel!
    
    @IBOutlet weak var daysLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
