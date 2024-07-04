//
//  ViewController.swift
//  ui4_pomodoro
//
//  Created by Nguyen Linh Chi on 25/06/2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var circleView: CircleView!
    var timer: Timer?
    var totalTime: TimeInterval = 25
    var elapsedTime: TimeInterval = 0.0
    var isRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetButton.layer.borderWidth = 2.0
        resetButton.layer.cornerRadius = 5
        resetButton.layer.borderColor = UIColor.white.cgColor
        
        startPauseButton.layer.cornerRadius = 5
        
        // Thiết lập font chữ, in đậm và màu chữ cho resetButton
        let resetButtonTitle = NSMutableAttributedString(
            string: "Reset",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 25),
                .foregroundColor: UIColor.white
            ]
        )
        resetButton.setAttributedTitle(resetButtonTitle, for: .normal)
        
        // Thiết lập font chữ, in đậm và màu chữ cho startPauseButton
        let startPauseButtonTitle = NSMutableAttributedString(
            string: "Start",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 25),
                .foregroundColor: UIColor.black
            ]
        )
        startPauseButton.setAttributedTitle(startPauseButtonTitle, for: .normal)
    }
    
    
//    @IBAction func startPauseButtonTapped(_ sender: UIButton) {
//        if isRunning {
//            pauseTimer()
//        } else {
//            startTimer()
//        }
//    }
//    
//    
//    @IBAction func resetButtonTapped(_ sender: UIButton) {
//        resetTimer()
//    }
}
