//
//  ViewController.swift
//  Calculator
//
//  Created by Stephen Negron on 8/31/16.
//  Copyright © 2016 Stephen Negron. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController { //Superclass (Inheritance)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var display: UILabel!
    @IBOutlet var history: UILabel!
    
    var userIsInMiddleOfTypingANumber = false, hasDecimalNumber = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInMiddleOfTypingANumber {
            if brain.isPI(digit) {
                //enter()
                displayValue = brain.pushConstant(digit)
                //enter()
                return
            }
            else if brain.hasDecimalPoint(digit) {
                if hasDecimalNumber {
                    display.text = "Error"
                    return
                } else {
                    hasDecimalNumber = true
                }
            }
            display.text = display.text! + digit
        } else {
            if brain.isPI(digit) {
                displayValue = brain.pushConstant(digit)
                //enter()
                return
            }
            display.text = digit
            userIsInMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func enter() {
        userIsInMiddleOfTypingANumber = false
        hasDecimalNumber = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = nil
        }
        history.text = brain.getHistory()
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue!)"
            userIsInMiddleOfTypingANumber = false
        }
    }
    @IBAction func operate(sender: UIButton) {
        if userIsInMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
        history.text = brain.getHistory()
    }
    @IBAction func clearView() {
        hasDecimalNumber = false
        displayValue = brain.clear()
        history.text = ""
    }
    @IBAction func setM(sender: UIButton) {
        userIsInMiddleOfTypingANumber = false
        brain.variableValues["M"] = displayValue
    }
    @IBAction func getM(sender: UIButton) {
        if userIsInMiddleOfTypingANumber {
            enter()
        }
        displayValue = brain.pushOperand("M")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Show Graph":
                if let vc = segue.destinationViewController as? GraphViewController {
                    vc.brain = self.brain
                    if let brainDescription = brain.description{
                        let descriptionArray = brainDescription.characters.split(",")
                        vc.graphTitle = String(descriptionArray.last)
                    }
                    
                }
            default: break
            }
        }
    }
}

