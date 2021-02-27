//
//  EmailRegisterViewController.swift
//  ChattyApp
//
//  Created by Zoli Nahoczki on 10/21/20.
//

import UIKit

class EmailRegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UnderlinedTextField!
    @IBOutlet weak var passTextField: UnderlinedTextField!
    @IBOutlet weak var confirmPassTextField: UnderlinedTextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    var firstname : String!
    var lastname : String!
    
    let api = ApiCalls()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        setup()
        
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        
        errorLabel.alpha = 0
        
        emailTextField.addTarget(self, action: #selector(textFieldDidStartEditing), for: .editingDidBegin)
        passTextField.addTarget(self, action: #selector(textFieldDidStartEditing), for: .editingDidBegin)
        emailTextField.addTarget(self, action: #selector(textFieldDidStopEditing), for: .editingDidEnd)
        passTextField.addTarget(self, action: #selector(textFieldDidStopEditing), for: .editingDidEnd)
        
        emailTextField.addBottomBorder()
        passTextField.addBottomBorder()
    }
    
    func showErrorLabel(_ errorMessage: String) {
        errorLabel.text = errorMessage
        errorLabel.alpha = 1
        print(errorMessage)
    }
    
    @objc private func textFieldDidStartEditing(_ sender: UnderlinedTextField) {
        sender.startEditing()
    }
    
    @objc private func textFieldDidStopEditing(_ sender: UnderlinedTextField) {
        sender.stopEditing()
    }
    
    @IBAction func registerPress(_ sender: Any) {
        
        guard let email = emailTextField.text else {
            showErrorLabel("Email field cannot be empty")
            return
        }
        
        guard let pass = passTextField.text else {
            showErrorLabel("Password field cannot be empty")
            return
        }
        
        guard let confirmPass = confirmPassTextField.text else {
            showErrorLabel("Confirm field cannot be empty")
            return
        }
        
        let cleanedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (cleanedEmail.isEmpty || pass.isEmpty || confirmPass.isEmpty) {
            showErrorLabel("One or more fields are empty")
            return
        }
        
        if (pass != confirmPass) {
            showErrorLabel("Passwords do not match")
            return
        }
        
        api.register(firstname: firstname, lastname: lastname, email: cleanedEmail, pass: pass) { (err) in
            if let err = err {
                self.showErrorLabel(err.message)
                return
            }
            
            self.performSegue(withIdentifier: "unwind", sender: self)
            
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
