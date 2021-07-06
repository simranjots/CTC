
import UIKit

class HistoryHeaderCellTableViewCell: UITableViewCell {

    @IBOutlet weak var HeaderTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.backgroundColor = Theme.navigationBarBackgroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
