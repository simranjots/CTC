import UIKit

class CircularViewController: UIViewController {
    
    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var progressView: CircularProgressView!
    @IBOutlet weak var percentageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cp = CircularProgressView(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        cp.progressColor = UIColor.yellow
        cp.trackColor = UIColor.red
        cp.center = self.view.center
        cp.tag = 304
        self.view.addSubview(cp)
        self.perform(#selector(animateProgress), with: nil, afterDelay: 2.0)
        
        progressView.trackColor = UIColor.lightGray
        progressView.progressColor = UIColor.red
        progressView.setProgressWithAnimation(duration: 2.0, value: 0.7)
        
        let displaylink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displaylink.add(to: .main, forMode: .default)
        
        let switchButton = UIButton(type: .custom)
        switchButton.isSelected = true
        switchButton.setImage(UIImage(named: "on-switch"), for: .selected)
        switchButton.setImage(UIImage(named: "off-switch"), for: .normal)
        switchButton.addSubview(switchButton)
    }
    
    var startValue: Double = 0
    var endValue: Double = 70
    var animationDuration: Double = 2.0
    let animationStartDate = Date()
    
    @objc func handleUpdate(){
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        if (elapsedTime > animationDuration) {
            self.percentageLabel.text = "\(Int(endValue))%"
        }
        else {
            let percentage = elapsedTime / animationDuration
            let value = startValue + percentage * (endValue - startValue)
            self.percentageLabel.text = "\(Int(value))%"
        }
    }
    
    @objc func animateProgress(){
        
        let cP = self.view.viewWithTag(304) as! CircularProgressView
        cP.setProgressWithAnimation(duration: 1.0, value: 1)
        
    }
    
}
