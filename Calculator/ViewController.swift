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
    
    var userIsInMiddleOfTypingANumber = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInMiddleOfTypingANumber = true
        }
    }

    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
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
        let operation = sender.currentTitle!
        if userIsInMiddleOfTypingANumber {
            enter()
        }
        switch operation {
            case "+": performOperation {$0 + $1}
            case "-": performOperation {$1 - $0}
            case "✕": performOperation {$0 * $1}
            case "/": performOperation {$1 / $0}
            case "sqrt": performOperation {sqrt($0)}
            case "π":
                displayValue = M_PI
                enter()
            default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
}

