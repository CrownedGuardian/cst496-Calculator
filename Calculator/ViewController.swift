//
//  ViewController.swift
//  Calculator
//
//  Created by Stephen Negron on 8/31/16.
//  Copyright © 2016 Stephen Negron. All rights reserved.
//

import UIKit

class ViewController: UIViewController { //Superclass (Inheritance)

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
            if brain.isPI(digit: digit) {
                //enter()
                displayValue = brain.pushConstant(symbol: digit)
                //enter()
                return
            }
            else if brain.hasDecimalPoint(digit: digit) {
                if hasDecimalNumber {
                    display.text = "Error"
                    return
                } else {
                    hasDecimalNumber = true
                }
            }
            display.text = display.text! + digit
        } else {
            if brain.isPI(digit: digit) {
                displayValue = brain.pushConstant(symbol: digit)
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
        if let result = brain.pushOperand(operand: displayValue!) {
            displayValue = result
        } else {
            displayValue = nil
        }
        history.text = brain.getHistory()
    }
    
    var displayValue: Double? {
        get {
            return NumberFormatter().number(from: display.text!)!.doubleValue
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
            if let result = brain.performOperation(symbol: operation) {
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
    @IBAction func setM(_ sender: UIButton) {
        userIsInMiddleOfTypingANumber = false
        brain.variableValues["M"] = displayValue
    }
    @IBAction func getM(_ sender: UIButton) {
        if userIsInMiddleOfTypingANumber {
            enter()
        }
        displayValue = brain.pushOperand(symbol: "M")
    }
}

