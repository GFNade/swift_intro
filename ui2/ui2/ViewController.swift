//
//  ViewController.swift
//  ui2
//
//  Created by Nguyen Linh Chi on 24/06/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var signInButton: UIView!
    @IBOutlet weak var signinFieldView: UIView!
    
    var isSignInExpanded = false
    
    @IBOutlet weak var signInButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var signInButtonTopConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        signInButton.layer.cornerRadius = 10
        signinFieldView.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signInButtonTapped(_:)))
                signInButton.addGestureRecognizer(tapGesture)
        
    }

    @objc func signInButtonTapped(_ sender: UIView){
        if isSignInExpanded {
            UIView.animate(withDuration: 0.3) {
                self.signInButtonTopConstraint.constant += 110;
                self.signInButtonHeight.constant += 50
                self.view.layoutIfNeeded()
                self.signinFieldView.isHidden = true
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.signInButtonTopConstraint.constant -= 110;
                self.signInButtonHeight.constant -= 50
                self.view.layoutIfNeeded()
                self.signinFieldView.isHidden = false
            }
        }
        isSignInExpanded.toggle()
    }
}

