//
//  AnimationLabel.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-01-25.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class AnimationLabel: UILabel {
    
    var counterValocity:Float = 3.0
    
    enum CounterAnimationType {
        case Linear  // f(x) = x
        case EaseIn  //  f(x) = x^3
        case EaseOut  //  f(x) = (1-x)^3
    }
    
    enum CounterType {
        case Int
        case Float
    }
    
    
    var startNumber:Float = 0.0
    var endNumber:Float = 0.0
    
    var progress: TimeInterval!
    var duration: TimeInterval!
    var lastUpdate: TimeInterval!
    
    var timer: Timer?
    
    var counterType: CounterType!
    var counterAnimationType: CounterAnimationType!
    
    
    var currentCounterValue:Float{
        
        if (progress >= duration){
            return endNumber
        }
        
        let percentage = Float(progress / duration)
        let update = updateCounter(counterValue: percentage)
        
        return startNumber + (update * (endNumber - startNumber))
        
    }
    
    
    func startAnimation(fromValue: Float, to toValue: Float, withDuration duration: TimeInterval, andAnimatonType animationType: CounterAnimationType, andCounterType counterType: CounterType){
        
        self.startNumber = fromValue
        self.endNumber = toValue
        self.duration = duration
        self.counterType = counterType
        self.counterAnimationType = animationType
        self.progress = 0
        self.lastUpdate = Date.timeIntervalSinceReferenceDate
        
        
        invalidateTimer()
        
        if(duration == 0){
            
            updateText(value: toValue)
            return
            
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(AnimationLabel.updateValue), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateValue(){
        
        let now = Date.timeIntervalSinceReferenceDate
        progress = progress + (now - lastUpdate)
        lastUpdate = now
        
        if(progress >= duration){
            
            invalidateTimer()
            progress = duration
            
        }
        
        // update text in label
        updateText(value: currentCounterValue)
        
    }
    
    func updateText(value: Float){
        
        switch counterType {
        case .Int?:
            self.text = "\(Int(value))%"
        case .Float?:
            self.text = "\(String(format: "%.2F", value))%"
        case .none:
            self.text = "Invalid Counter Number Type"
        }
        
    }
    
    func updateCounter(counterValue: Float) -> Float{
        
        switch counterAnimationType {
        case .Linear?:
            return counterValue
        case .EaseIn?:
            return powf(counterValue, counterValocity)
        case .EaseOut?:
            return 1.0 - powf(1.0 - counterValue, counterValocity)
        case .none:
            return 0.0
        }
      
    }
    
    func invalidateTimer(){
        
        timer?.invalidate()
        timer = nil
        
    }
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
