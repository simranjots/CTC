
import UIKit

class CircularProgressView: UIView {
    
    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var trackLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }

    var progressColor = UIColor.white{
        didSet{
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var trackColor = UIColor.white{
        didSet{
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    fileprivate func createCircularPath() {
        
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width/2
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width-1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.57 + .pi), clockwise: true)
        
        //Properties of tracking path
        trackLayer.path = circlePath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = 15.0
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)
        
        //Properties of Progress path
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = trackColor.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 15.0
        progressLayer.strokeEnd = 0.0
        layer.addSublayer(progressLayer)
        
    }
    
    func setProgressWithAnimation(duration: TimeInterval, value: Float){
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction( name: CAMediaTimingFunctionName.linear)
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.add(animation, forKey: "animatepregress")
        
    }
}
