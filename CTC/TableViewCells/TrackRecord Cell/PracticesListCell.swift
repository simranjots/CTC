import UIKit

class PracticesListCell: UITableViewCell {

    
    
    //Tablview Views
    @IBOutlet var stataticsVCMainContainer: UIView!
    @IBOutlet var headerTitleView: UIView!
    @IBOutlet var circularBarAndStataticsView: UIView!
    @IBOutlet var circularProgressBarView: StataticsViewProgressBar!
    
    
    //TableView Labels
    @IBOutlet var activityHeaderTitleLabel: UILabel!
    @IBOutlet var tagLineLabel: UILabel!
    @IBOutlet var howManyDaysActivityPracticedLabel: UILabel!
    @IBOutlet var daysSinceStartedLabel: UILabel!
    @IBOutlet var activityPracticedForThisMonthLabel: UILabel!
    @IBOutlet var streakLabel: UILabel!
    @IBOutlet var percentageLabel: AnimationLabel!
    
    //TableView Label Titles
    @IBOutlet var daysLabelTitle: UILabel!
    @IBOutlet var daysSinceStartedLabelTitle: UILabel!
    @IBOutlet var streakLabelTitle: UILabel!
    @IBOutlet var thisMonthLabelTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        styleViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Style progressbar
    func setPercentageAnimation(percentageValue: Int){
        
        let percentageFloat : Float = Float(percentageValue)
        let percentageInPoint : Float = percentageFloat / 100
        
        circularProgressBarView.trackColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        circularProgressBarView.progressColor = #colorLiteral(red: 0, green: 0.7097216845, blue: 0.6863465309, alpha: 1)
        circularProgressBarView.setProgressWithAnimation(duration: 1.0, value: percentageInPoint)
        percentageLabel.text = "\(percentageValue)%"
        
    }
    
    //Style Views
    func styleViews() {
        
        //Set properties of activityTitleView
        headerTitleView.layer.cornerRadius = headerTitleView.frame.height / 4
        headerTitleView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        headerTitleView.layer.borderWidth = 1
//        headerTitleView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        headerTitleView.layer.shadowOpacity = 0.9
//        headerTitleView.layer.shadowOffset = .zero
//        headerTitleView.layer.shadowRadius = 4
        
        //Set properties of ProgressView
        circularBarAndStataticsView.layer.borderColor = #colorLiteral(red: 0, green: 0.7097216845, blue: 0.6863465309, alpha: 1)
        circularBarAndStataticsView.layer.borderWidth = 1
//        circularBarAndStataticsView.layer.shadowColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
//        circularBarAndStataticsView.layer.shadowOpacity = 0.9
//        circularBarAndStataticsView.layer.shadowOffset = .zero
//        circularBarAndStataticsView.layer.shadowRadius = 4
    }

    

}
