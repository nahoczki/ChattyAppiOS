//
//  LoginViewController.swift
//  ChattyApp
//
//  Created by Zoli Nahoczki on 10/13/20.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: CustomSpinnerButton!
    
    @IBOutlet weak var emailTextField: UnderlinedTextField!
    @IBOutlet weak var passTextField: UnderlinedTextField!
    
    var press = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        setup()
        
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        let screenSize: CGRect = UIScreen.main.bounds
        loginButton.widthAnchor.constraint(equalToConstant: screenSize.width - (50 * 2)).isActive = true
        
        emailTextField.addTarget(self, action: #selector(textFieldDidStartEditing), for: .editingDidBegin)
        passTextField.addTarget(self, action: #selector(textFieldDidStartEditing), for: .editingDidBegin)
        emailTextField.addTarget(self, action: #selector(textFieldDidStopEditing), for: .editingDidEnd)
        passTextField.addTarget(self, action: #selector(textFieldDidStopEditing), for: .editingDidEnd)
        
        emailTextField.addBottomBorder()
        passTextField.addBottomBorder()
    }
    
    @objc private func textFieldDidStartEditing(_ sender: UnderlinedTextField) {
        sender.startEditing()
    }
    
    @objc private func textFieldDidStopEditing(_ sender: UnderlinedTextField) {
        sender.stopEditing()
    }
    
    @IBAction func loginPress(_ sender: CustomSpinnerButton) {
        sender.startLoading()
        
        _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            sender.stopLoading()
        }
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
