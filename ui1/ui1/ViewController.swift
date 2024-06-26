//
//  ViewController.swift
//  ui1
//
//  Created by Nguyen Linh Chi on 18/06/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var imgSmall: UIImageView!
    
    @IBOutlet weak var ultimate: UIButton!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var star: UILabel!
    @IBOutlet weak var medal: UILabel!
    
    var isOriginalState = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        let blurFrame = CGRect(x: 0, y: img.bounds.height / 2, width: 300, height: img.bounds.height / 2)
        blurView.frame = blurFrame
        img.addSubview(blurView)
        
        let blurEffectSmall = UIBlurEffect(style: .extraLight)
        let blurViewSmall = UIVisualEffectView(effect: blurEffectSmall)
        let blurFrameSmall = CGRect(x: 0, y: imgSmall.bounds.height / 2, width: 50, height: imgSmall.bounds.height / 2)
        blurViewSmall.frame = blurFrameSmall
        imgSmall.addSubview(blurViewSmall)
        
        name.textColor = .black
        star.textColor = .gray
        medal.textColor = .gray
        ultimate.addTarget(self, action: #selector(ultimateTapped), for: .touchUpInside)
    }
    
    @objc func ultimateTapped() {
            if isOriginalState {
                name.text = "  nmint888..."
                name.textColor = .black
                name.font = .boldSystemFont(ofSize: 16)
                star.text = "999,999"
                star.textColor = .gray
                star.font = .systemFont(ofSize: 16)
                medal.text = "999,999 "
                medal.textColor = .gray
                medal.font = .systemFont(ofSize: 16)
            } else {
                name.text = "  nmint8m"
                name.textColor = .black
                name.font = .boldSystemFont(ofSize: 16)
                star.text = "99"
                star.textColor = .gray
                star.font = .systemFont(ofSize: 16)
                medal.text = "99 "
                medal.textColor = .gray
                medal.font = .systemFont(ofSize: 16)
            }
            isOriginalState.toggle()
        }
    
    
}

