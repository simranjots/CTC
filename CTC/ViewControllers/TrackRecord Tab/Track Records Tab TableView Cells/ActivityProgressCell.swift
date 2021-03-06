import UIKit

class ActivityProgressCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet var activityTrackView: UIView!
    @IBOutlet var activityDateLabel: UILabel!
    @IBOutlet var activityNotesTextView: UITextView!
    @IBOutlet var practicedDaysLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        activityTrackView.layer.cornerRadius = activityTrackView.frame.height / 10
        activityTrackView.layer.borderColor = #colorLiteral(red: 0, green: 0.7097216845, blue: 0.6863465309, alpha: 1)
        activityTrackView.layer.borderWidth = 1
        activityNotesTextView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        activityNotesTextView.layer.borderWidth = 0.1
        activityNotesTextView.layer.cornerRadius = activityTrackView.frame.height / 10
        activityNotesTextView.returnKeyType = .done
        activityNotesTextView.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "No note created." {
            textView.text = ""
            textView.textColor = UIColor.black
            textView.font = UIFont(name: "verdana", size: 18.0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "No note created."
            textView.textColor = UIColor.lightGray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }

}
