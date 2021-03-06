//
//  TabBarViewController.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-24.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBar {

    private var shapeLayer: CALayer?
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        
        //Create path
        shapeLayer.path = createPath()
        
        //Set the properties
        shapeLayer.fillColor = Utilities.primaryTextColor.cgColor
//        shapeLayer.strokeColor = UIColor.clear.cgColor
//        shapeLayer.borderColor = Utilities.primaryBorderColor.cgColor
//        shapeLayer.borderWidth = 1
//        shapeLayer.lineWidth = 1.0
//        shapeLayer.shadowOffset = CGSize(width: 0.0, height: 5)
//        shapeLayer.shadowColor = UIColor.black.cgColor
//        shapeLayer.shadowOpacity = 1.0

        //Add shape
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    //Add tabbar shape and set properties
    override func draw(_ rect: CGRect) {
        self.addShape()
        self.unselectedItemTintColor = UIColor.white
        self.tintColor = Utilities.primaryBorderColor
    }
    
    func createPath() -> CGPath {
        
        //Set height and width
        let height: CGFloat = 15
        let centerWidth = self.frame.width / 2
        let path = UIBezierPath()
       
        path.move(to: CGPoint(x: 0, y: -20)) //Start position
        path.addLine(to: CGPoint(x: centerWidth - 50, y: 0)) //Left Slope
        path.addQuadCurve(to: CGPoint(x: centerWidth - 30, y: 20), controlPoint: CGPoint(x: centerWidth - 30, y: 5)) //Top left curve
        path.addLine(to: CGPoint(x: centerWidth - 29, y: height - 10)) //Left vertical line
        path.addQuadCurve(to: CGPoint(x: centerWidth, y: height + 10), controlPoint: CGPoint(x: centerWidth - 30, y: height + 10)) //bottom left curve
        path.addQuadCurve(to: CGPoint(x: centerWidth + 40, y: height - 10), controlPoint: CGPoint(x: centerWidth + 40, y: height + 10)) //bottom right curve
        path.addLine(to: CGPoint(x: centerWidth + 41, y: 20)) //Right Vertical line
        path.addQuadCurve(to: CGPoint(x: centerWidth + 50, y: 0), controlPoint: CGPoint(x: centerWidth + 41, y: 5)) //top right curve
        path.addLine(to: CGPoint(x: self.frame.width, y: -20)) //Right Slope
        
        //Close path
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        return path.cgPath
    }
}
