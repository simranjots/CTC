//
//  ActivityDetailsProgressBarView.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-13.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit

class ActivityDetailsProgressBarView: UIView {

    var progressLayer = CAShapeLayer()
    var trackLayer = CAShapeLayer()
    
    //Required init function as designed through storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeCircularPath()
    }
        
        
        //Setting the properties of progressLayer and TrackLayer
        var progressColor = UIColor.white {
            didSet {
                progressLayer.strokeColor = progressColor.cgColor
            }
        }
        
        var trackColor = UIColor.white {
            didSet {
                trackLayer.strokeColor = trackColor.cgColor
            }
        }
        
        //Creating a circular path, defining the parameters of it and it’s behaviour.
        func makeCircularPath() {
            
            self.backgroundColor = UIColor.clear
            self.layer.cornerRadius = self.frame.size.width / 2
            
            //Starting point: (-pi / 2) = -0.5 * pi
            //Ending point: (3 * pi / 2) = 1.5 * pi
            
            let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2), radius: (frame.size.width - 1.5) / 2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
            
            //Properties of tracking path
            trackLayer.path = circularPath.cgPath
            trackLayer.fillColor = UIColor.clear.cgColor
            trackLayer.strokeColor = trackColor.cgColor
            trackLayer.lineWidth = 15.0
            trackLayer.strokeEnd = 1.0
            layer.addSublayer(trackLayer)
            
            //Properties of Progress path
            progressLayer.path = circularPath.cgPath
            progressLayer.fillColor = UIColor.clear.cgColor
            progressLayer.strokeColor = trackColor.cgColor
            progressLayer.lineCap = .round
            progressLayer.lineWidth = 15.0
            progressLayer.strokeEnd = 0.0
            layer.addSublayer(progressLayer)
        }
        
        //Progressbar Animation
        
        func setProgressWithAnimation(duration: TimeInterval, value: Float) {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = duration
            animation.fromValue = 0
            animation.toValue = value
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            
            progressLayer.strokeEnd = CGFloat(value)
            progressLayer.add(animation, forKey: "animateProgress")
            
        }

}
