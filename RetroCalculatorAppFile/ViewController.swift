//
//  ViewController.swift
//  RetroCalculator
//
//  Created by SEAN on 2017/7/26.
//  Copyright © 2017年 SEAN. All rights reserved.
//

import UIKit
import AVFoundation  //使用影音功能

class ViewController: UIViewController {

    var btnSound: AVAudioPlayer!
    
    @IBOutlet weak var outputLbl: UILabel!
    
    var runningNumber = ""
    var currentOperation = Operation.Empty
    var leftValString = ""
    var RightValString = ""
    var result = ""
    
    enum Operation: String{
        case Divide = "/"
        case Multiply = "*"
        case Add = "+"
        case Subtract = "-"
        case Empty = "Empty"
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
   
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        //path is the type of string
        
        let soundURL = URL(fileURLWithPath: path!)
        // Change the string into URL
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
            
        }catch let err as NSError //if URL 無法抓取（或網路無法連線）
        {
            print(err.debugDescription)
        }
        outputLbl.text = "0"
    }
    
    
    func playSound() {
        if btnSound.isPlaying{
            btnSound.stop() //避免點擊太快聲音重複太雜亂
        }
        btnSound.play()
    }
    
    
    @IBAction func numberPressed(sender: UIButton){
        
        playSound()
    
        
        runningNumber += "\(sender.tag)" //顯示多位數的數字
        outputLbl.text = runningNumber
        
    }
    @IBAction func onDividePressed(sender:Any){
        processOperation(operation: .Divide)
    }
    @IBAction func onMultiplyPressed(sender:Any){
        processOperation(operation: .Multiply)
    }
    @IBAction func onSubtractPressed(sender:Any){
        processOperation(operation: .Subtract)
    }
    @IBAction func onAddPressed(sender:Any){
        processOperation(operation: .Add)
    }
    @IBAction func onEqualPressed(sender:Any){
        processOperation(operation: currentOperation)
    }
    
    //reset
    @IBAction func resetBtnPressed(_ sender: UIButton) {
        runningNumber = ""
        currentOperation = Operation.Empty
        leftValString = ""
        RightValString = ""
        result = ""
        outputLbl.text = "0"
    }
    

    
    //math logic
    func  processOperation(operation: Operation){
        
        playSound()
        
        
        if currentOperation != Operation.Empty{
            
            // A user selected an operator, but then selected another operator without first enerting a number
            
            if runningNumber != ""{
                RightValString = runningNumber
                runningNumber = ""
                
                //如果一開始都沒數字直接用operation，初數字定為0
                // if leftValString == "" {
                //    leftValString = "0"
                //}
                
                if currentOperation == Operation.Multiply{
                    result = "\(Double(leftValString)! * Double(RightValString)!)"
                    
                
                }else if currentOperation == Operation.Divide{
                    result = "\(Double(leftValString)! / Double(RightValString)!)"
                
                }else if currentOperation == Operation.Subtract{
                    result = "\(Double(leftValString)! - Double(RightValString)!)"
                
                }else if currentOperation == Operation.Add{
                    result = "\(Double(leftValString)! + Double(RightValString)!)"
                
                }
                
                leftValString = result
                outputLbl.text = result
            }
            
            currentOperation = operation
        }else{
            //This is the first time an operator has been pressed
            leftValString = runningNumber
            runningNumber = ""
            currentOperation = operation
        }


}

}
