//
//  ViewController.swift
//  ui5_login
//
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginDetailsLabel: UILabel!
    @IBOutlet weak var loginImage: UIImageView!
    @IBOutlet weak var userErrorLabel: UILabel!
    @IBOutlet weak var userInputTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginDetailsLabel.textColor = .black
        userErrorLabel.isHidden = true
        userInputTextField.layer.cornerRadius = 5
        userInputTextField.layer.masksToBounds = true
        userInputTextField.layer.borderWidth = 1.0
        userInputTextField.layer.borderColor = UIColor.gray.cgColor
        
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor.gray.cgColor

        let placeholderColor = UIColor.lightGray // Bạn có thể thay đổi màu sắc tại đây
                userInputTextField.attributedPlaceholder = NSAttributedString(
                    string: "Username , email & phone number",
                    attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
                )
                passwordTextField.attributedPlaceholder = NSAttributedString(
                    string: "Password",
                    attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
                )
        userInputTextField.delegate = self
        passwordTextField.delegate = self
       
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = userInputTextField.text else { return }

        if isValidEmail(email) {
            // Email hợp lệ
            userErrorLabel.isHidden = true
            // Thực hiện các hành động tiếp theo khi email hợp lệ
            loginImage.image = UIImage(named: "xanh")
        } else {
            // Email không hợp lệ
            userErrorLabel.isHidden = false
            loginImage.image = UIImage(named: "hong") // Thay "errorImage" bằng tên ảnh lỗi của bạn
            loginButton.layer.opacity = 0.3
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Khi có bất kỳ thay đổi nào trong text field, khôi phục trạng thái ban đầu của loginButton và userErrorLabel
        userErrorLabel.isHidden = true
//        loginImage.image = nil
        loginButton.layer.opacity = 1.0
        
        return true
    }
}
