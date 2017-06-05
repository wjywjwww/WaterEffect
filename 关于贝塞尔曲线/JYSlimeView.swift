//
//  JYSlimeView.swift
//  关于贝塞尔曲线
//
//  Created by sks on 17/6/5.
//  Copyright © 2017年 besttone. All rights reserved.
//

import UIKit

class JYSlimeView: UIView {
    var brokeDistance : CGFloat = 150.0
    var shapeLayer : CAShapeLayer = CAShapeLayer()
    var headDot : JYSlimeDot = JYSlimeDot(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    var trailDot : JYSlimeDot = JYSlimeDot(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    override init(frame: CGRect) {
        super.init(frame: frame)
        shapeLayer.fillColor = ConvenienceTool.colorFromRGBA(red: 52, green: 152, blue: 219, alpha: 1).cgColor
        shapeLayer.anchorPoint = CGPoint.zero
        shapeLayer.position = CGPoint.zero
        shapeLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        self.layer.addSublayer(shapeLayer)
        headDot.center = self.center
        trailDot.center = self.center
       
        self.addSubview(trailDot)
        self.addSubview(headDot)
        let pan : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(JYSlimeView.panAction(sender:)))
        headDot.addGestureRecognizer(pan)
    }
    func panAction(sender : UIPanGestureRecognizer){
        
        switch sender.state {
            
        case UIGestureRecognizerState.changed:
            let point = sender.location(in: self.headDot.superview)
            self.headDot.center = point
            let distance = getDistance()
            if distance < brokeDistance{
                let scale = max(1 - distance / brokeDistance, 0.55)
                self.trailDot.transform = CGAffineTransform(scaleX: scale, y: scale)
                self.headDot.transform = CGAffineTransform(scaleX: scale, y: scale)
                reloadBezierPath()
            }else{
                broke()
            }
            break
        case UIGestureRecognizerState.ended:
            placeHeadDot()
            break
        default:
            break
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func getInstance()->JYSlimeView{
        let view = JYSlimeView(frame: CGRect(x: 0, y: 0, width: ConvenienceTool.SCREEN_WIDTH, height: ConvenienceTool.SCREENH_HEIGHT))
        return view
    }
    func reloadBezierPath(){
        
        let r1 = self.trailDot.frame.width / 2
        let x1 = self.trailDot.center.x
        let y1 = self.trailDot.center.y
        
        let r2 = self.headDot.frame.width / 2
        let x2 = self.headDot.center.x
        let y2 = self.headDot.center.y
        let distance = sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
        
        let cosQ = (y2 - y1) / distance
        let sinQ = (x2 - x1) / distance
        
        let pointA = CGPoint(x: x1 - r1 * cosQ, y: y1 + r1 * sinQ)
        let pointB = CGPoint(x: x1 + r1 * cosQ, y: y1 - r1 * sinQ)
        let pointC = CGPoint(x: x2 - r2 * cosQ, y: y2 + r2 * sinQ )
        let pointD = CGPoint(x: x2 + r2 * cosQ, y: y2 - r2 * sinQ)
        let pointO = CGPoint(x: pointA.x  + distance/2 * sinQ, y: pointA.y + distance/2 * cosQ)
        let pointP = CGPoint(x: pointB.x + distance/2 * sinQ, y: pointA.y + distance/2 * cosQ)
        
        let pathTemp = UIBezierPath()
        pathTemp.move(to: pointA)
        pathTemp.addQuadCurve(to: pointC, controlPoint: pointO)
        pathTemp.addLine(to: pointD)
        pathTemp.addQuadCurve(to: pointB, controlPoint: pointP)
        pathTemp.addLine(to: pointA)
        self.shapeLayer.path = pathTemp.cgPath
    }
    func getDistance()->CGFloat{
        let trailDotX : CGFloat = self.trailDot.center.x
        let trailDotY: CGFloat = self.trailDot.center.y
    
        let headDotX = self.headDot.center.x
        let headDotY = self.headDot.center.y

        let distance = sqrt((trailDotX - headDotX) * (trailDotX - headDotX) + (trailDotY - headDotY) * (trailDotY - headDotY))
        return distance
    }
    func broke(){
        self.shapeLayer.path = nil
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { 
            self.trailDot.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.headDot.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    func placeHeadDot(){
        broke()
        self.shapeLayer.path = nil
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { 
            self.headDot.center = self.center
        }, completion: nil)
    }
}
class JYSlimeDot: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = ConvenienceTool.colorFromRGBA(red: 52, green: 152, blue: 219, alpha: 1)
        self.layer.cornerRadius = frame.size.width / 2.0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

















