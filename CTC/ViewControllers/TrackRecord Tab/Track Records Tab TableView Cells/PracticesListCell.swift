import UIKit

class PracticesListCell: UITableViewCell {
    
    //MARK: - Outlets
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
    
    @IBOutlet weak var starteddayLabel: UILabel!
    
    @IBOutlet weak var streakdaylabel: UILabel!
    @IBOutlet weak var monthdaylabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        //Set properties of activityTitleView
        headerTitleView.layer.cornerRadius = headerTitleView.frame.height / 4
        starteddayLabel.layer.cornerRadius = starteddayLabel.frame.height / 4
        streakdaylabel.layer.cornerRadius = streakdaylabel.frame.height / 4
        monthdaylabel.layer.cornerRadius = monthdaylabel.frame.height / 4
        
        Utilities.adddayBorderToView(monthdaylabel)
        Utilities.adddayBorderToView(streakdaylabel)
        Utilities.adddayBorderToView(starteddayLabel)
        Utilities.addShadowAndBorderToView(headerTitleView)
        
        //Set properties of ProgressView
        Utilities.addShadowAndBorderToView(circularBarAndStataticsView)
        circularProgressBarView.layer.borderWidth = 0
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
}
