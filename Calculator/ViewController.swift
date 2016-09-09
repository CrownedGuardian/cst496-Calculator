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
    
    var userIsInMiddleOfTypingANumber = false, hasDecimalNumber = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInMiddleOfTypingANumber {
            if brain.hasDecimalPoint(digit) {
                if hasDecimalNumber {
                    display.text = "Error"
                    return
                } else {
                    hasDecimalNumber = true
                }
            }
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func enter() {
        userIsInMiddleOfTypingANumber = false
        hasDecimalNumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
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
                displayValue = 0
            }
        }
    }
    @IBAction func clearView() {
        hasDecimalNumber = false
        displayValue = brain.clear()
    }
    
}

