//
//  GraphView.swift
//  Calculator
//
//  Created by Stephen Negron on 10/21/16.
//  Copyright © 2016 Stephen Negron. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func yCoordinate(sender: GraphView,xCoordinate: CGFloat) -> CGFloat?
}

@IBDesignable
class GraphView: UIView {
    
    @IBInspectable
    var originX:CGFloat = 0 { didSet { setNeedsDisplay() }}
    @IBInspectable
    var originY:CGFloat = 0 { didSet { setNeedsDisplay() }}
    var ppi:CGFloat = 50
    
    @IBInspectable
    var pinchScale:CGFloat = 1 { didSet { setNeedsDisplay() }}
    
    weak var dataSource:GraphViewDataSource?
    
    var scale:CGFloat {
        get {
            return ppi * pinchScale
        }
    }
    var origin:CGPoint {
        get {
            return CGPoint(x:self.center.x + originX,y:self.center.y + originY)
        }
    }
    
    
    
    var firstValue:Bool = true
    
    func scale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            pinchScale *= gesture.scale
            gesture.scale = 1.0
        }
    }
    
    func pan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Changed: fallthrough
        case .Ended:
            let translation = gesture.translationInView(self)
            originX += translation.x
            originY += translation.y
            gesture.setTranslation(CGPointZero, inView: self)
        default: break
        }
    }
    
    func moveOrigin(gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .Ended:
            originX = -self.center.x + gesture.locationInView(self).x
            originY = -self.center.y + gesture.locationInView(self).y
        default: break
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        
        let graphDrawer = GraphDrawer()
        graphDrawer.contentScaleFactor = contentScaleFactor
        graphDrawer.drawAxesInRect(self.bounds,origin:origin,pointsPerUnit: scale)
        
        if dataSource != nil {
            let path = UIBezierPath()
            var point = CGPoint()
            for i in 0 ..< Int(self.bounds.size.width * contentScaleFactor)  {
                point.x = CGFloat(i) / contentScaleFactor
                
                if let y = dataSource?.yCoordinate(self, xCoordinate: (point.x - origin.x) / scale) {
                    point.y = origin.y - (CGFloat(y) * scale)
                    if firstValue {
                        path.moveToPoint(point)
                        firstValue = false
                    } else {
                        path.addLineToPoint(point)
                    }
                }
                
            }
            
            UIColor.blackColor().setStroke()
            path.lineWidth = 1.0
            path.stroke()
            firstValue = true
            
        }
    }
}