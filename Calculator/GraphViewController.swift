//
//  GraphViewController.swift
//  Calculator
//
//  Created by Stephen Negron on 10/23/16.
//  Copyright © 2016 Stephen Negron. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource  {
    
    var brain:CalculatorBrain?
    var graphTitle: String? {
        didSet{
            self.title = graphTitle
        }
    }
    
    @IBOutlet var graphView: GraphView!{
        didSet {
            graphView.dataSource = self
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView,action: Selector("scale:")))
            
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView,action: Selector("pan:")))
            
            let doubleTap = UITapGestureRecognizer(target: graphView, action: Selector("moveOrigin:"))
            doubleTap.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(doubleTap)
        }
    }
    
    func yCoordinate(sender: GraphView,xCoordinate: CGFloat) -> CGFloat? {
        brain?.variableValues["M"] = Double(xCoordinate)
        if let y = brain?.evaluate(){
            return CGFloat(y)
        }
        return nil
    }

}
