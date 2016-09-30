//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Stephen Negron on 9/7/16.
//  Copyright © 2016 Stephen Negron. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, (Double) -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Variable(String)
        case Constant(String, Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .Variable(let symbol):
                    return "\(symbol)"
                case .Constant(let symbol, _):
                    return "\(symbol)"
                }
            }
        }
        
        /*var precedence: Int {
            get {
                switch self {
                case .Operand(_):
                    return Int.max
                }
            }
        }*/
    }
    
    private var opStack = [Op]()    //Array
    
    
    private var knownOps = [String:Op]() //Dictionary
    var variableValues = [String:Double]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") {$1 - $0})
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") {$1 / $0})
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.Constant("π", M_PI))
    }
    
    private func getDescription(oldDescription: [String], ops: [Op]) -> (newDescription: [String], remainingsOps: [Op]) {
        var newDescription = oldDescription
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeFirst()
            switch op {
            case .Operand(_), .Variable(_), .Constant(_, _):
                newDescription.append(op.description)
                return getDescription(newDescription, ops: remainingOps)
            case .UnaryOperation(let symbol, _):
                if !newDescription.isEmpty {
                    let operand = newDescription.removeLast()
                    newDescription.append(symbol + "(\(operand))")
                    let (newestDescription, remainingOPs) = getDescription(newDescription, ops: remainingOps)
                    return (newestDescription, remainingOPs)
                }
            case .BinaryOperation(let symbol, _):
                if !newDescription.isEmpty {
                    let lastOperand = newDescription.removeLast()
                    if !newDescription.isEmpty {
                        let firstOperand = newDescription.removeLast()
                        if op.description == remainingOps.first?.description {
                            newDescription.append("\(firstOperand)" + symbol + "\(lastOperand)")
                        } else {
                            newDescription.append("(\(firstOperand)" + symbol + "\(lastOperand))")
                        }
                        return getDescription(newDescription, ops: remainingOps)
                    } else {
                        newDescription.append("?" + symbol + "\(lastOperand)")
                        return getDescription(newDescription, ops: remainingOps)
                    }
                } else {
                    newDescription.append("?" + symbol + "?")
                    return getDescription(newDescription, ops: remainingOps)
                }
            }
        }
        return (newDescription, ops)
    }
    
    var description: String {
        let (descriptions, _) = getDescription([String](), ops: opStack)
        return descriptions.joinWithSeparator(", ")
    }
    
    /*typealias PropertyList = AnyObject
    
    var program: PropertyList {    //guaranteed to be a PropertyList
        get {
            return opStack.map {$0.description} //returns array of every op's description
        }
        set {
            if let opSymbols = newValue as? Array<String> { //casting
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NumberFormatter().number(from: opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
                opStack = newOpStack
            }
        }
    }*/
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .Variable(let symbol):
                if let value = variableValues[symbol] {
                    return (value, remainingOps)
                } else {
                    return (nil, remainingOps)
                }
            case .Constant(_, let value):
                return (value, remainingOps)
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func pushConstant(symbol: String) -> Double? {
        if let constant = knownOps[symbol] {
            opStack.append(constant)
        }
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clear() -> Double {
        if !opStack.isEmpty {
            opStack.removeAll()
        }
        if !variableValues.isEmpty {
            variableValues.removeAll()
        }
        return 0
    }
    
    func hasDecimalPoint(digit: String) -> Bool{
        if digit == "." {
            return true
        }
        return false
    }
    
    func isPI(digit: String) -> Bool {
        if digit == "π" {
            return true
        }
        return false
    }
    
    func getPI() -> Double{
        return M_PI
    }
    
    func getHistory() -> String{
        return "\(description)="
        //return opStack.description
    }
}
