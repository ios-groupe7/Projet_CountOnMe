//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "X" && elements.last != "/"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "/" && elements.last != "X"
    }
    
    var expressionHaveResult: Bool {
        return textView.text.firstIndex(of: "=") != nil
    }
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        
        if expressionHaveResult {
            textView.text = ""
        }
        
        if (textView.text == "0") {
            textView.text = numberText
        } else {
            textView.text.append(numberText)
        }
    }
    
    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        if (canAddOperator) {
            textView.text.append(" / ")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedAcButton(_ sender: UIButton) {
        textView.text = "0"
    }
    
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        if (canAddOperator) {
            textView.text.append(" X ")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append(" + ")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append(" - ")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    func calculateExpression (left:String,right:String ,operand: String ) -> Int{
        let left = Int(left)!
        let operand = operand
        let right = Int(right)!
        
        let result: Int
        switch operand {
        case "+": result = left + right
        case "-": result = left - right
        case "/": result = left / right
        case "X": result = left * right
        default: fatalError("Unknown operator !")
        }
        return result
    }

    func evaluatePriority(operand:String,indice: Int, expression:[String]) -> [String]{
        var result : Int
            result = calculateExpression(left: expression[indice-1], right: expression[indice+1], operand: operand)
            var copyExpression = expression
            copyExpression[indice-1] = String(result)
            copyExpression.remove(at: indice)
            copyExpression.remove(at: indice)
            return copyExpression
    }

    func operationPriority(expression:[String]) -> Int{
        let listOperand = ["/","X"]
        var copyExpression = expression
        var i = 0
        while  (i<listOperand.count) {
           var findIndex = copyExpression.firstIndex(of: listOperand[i])
            while (findIndex != nil) {
                copyExpression = evaluatePriority(operand: listOperand[i], indice:findIndex! , expression: copyExpression)
                findIndex = copyExpression.firstIndex(of: listOperand[i])
            }
            i+=1
        }
        while copyExpression.count >= 3 {
            let left = copyExpression[0]
            let operand = copyExpression[1]
            let right = copyExpression[2]
            let result = calculateExpression(left: left, right: right, operand: operand)
            copyExpression = Array(copyExpression.dropFirst(3))
            copyExpression.insert("\(result)", at: 0)
        }
        return Int(copyExpression.joined())!
    }
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard expressionIsCorrect else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Entrez une expression correcte !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        
        guard expressionHaveEnoughElement else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Démarrez un nouveau calcul !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        
        // Create local copy of operations
        let operationsToReduce = elements
        print(operationsToReduce)
        // Iterate over operations while an operand still here
        textView.text.append(" = \(operationPriority(expression:operationsToReduce))")
    }

}

