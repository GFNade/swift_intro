//
//  ViewController.swift
//  ui4_pomodoro
//
//  Created by Nguyen Linh Chi on 25/06/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startPauseButton: UIButton!
    
    var timer: Timer?
    var isTimerRunning = false
    var isWorkTime = true
    var remainingTime = 1500
    
    let circularLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timeLabel.font = UIFont.systemFont(ofSize: 60.0)
        timeLabel.layer.cornerRadius = timeLabel.bounds.width / 2 + 10
        timeLabel.layer.borderWidth = 10.0 // Độ dày của viền
        timeLabel.layer.borderColor = UIColor.orange.cgColor
        
        resetButton.layer.borderWidth = 3.0 // Độ dày của viền
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
                
        
        updateLabel()
       
    }
    

    @IBAction func startPauseTapped(_ sender: UIButton) {
            if isTimerRunning {
                pauseTimer()
            } else {
                startTimer()
            }
        }
        
        @IBAction func resetTapped(_ sender: UIButton) {
            resetTimer()
        }
        
        func startTimer() {
            if timer == nil {
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            }
            isTimerRunning = true
            let pauseButtonTitle = NSMutableAttributedString(
                        string: "Pause",
                        attributes: [
                            .font: UIFont.boldSystemFont(ofSize: 25),
                            .foregroundColor: UIColor.black
                        ]
                    )
                    startPauseButton.setAttributedTitle(pauseButtonTitle, for: .normal)
        }
        
        func pauseTimer() {
            timer?.invalidate()
            timer = nil
            isTimerRunning = false
            let startButtonTitle = NSMutableAttributedString(
                        string: "Start",
                        attributes: [
                            .font: UIFont.boldSystemFont(ofSize: 25),
                            .foregroundColor: UIColor.black
                        ]
                    )
                    startPauseButton.setAttributedTitle(startButtonTitle, for: .normal)
        }
        
        func resetTimer() {
            pauseTimer()
            remainingTime = isWorkTime ? 1500 : 300 // 25 phút làm việc hoặc 5 phút nghỉ
            updateLabel()
        }
        
        @objc func updateTimer() {
            if remainingTime > 0 {
                remainingTime -= 1
                updateLabel()
            } else {
                timer?.invalidate()
                timer = nil
                isTimerRunning = false
                startPauseButton.setTitle("Start", for: .normal)
                isWorkTime.toggle()
                remainingTime = isWorkTime ? 1500 : 300
            }
        }
        
        func updateLabel() {
            let minutes = remainingTime / 60
            let seconds = remainingTime % 60
            timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
            
        }
}

