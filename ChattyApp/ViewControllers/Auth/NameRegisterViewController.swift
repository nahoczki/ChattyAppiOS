//
//  RegisterViewController.swift
//  ChattyApp
//
//  Created by Zoli Nahoczki on 10/21/20.
//

import UIKit

class NameRegisterViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UnderlinedTextField!
    @IBOutlet weak var lastNameTextField: UnderlinedTextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var firstname : String!
    var lastname : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        setup()
        
        
        // Do any additional setup after loading the view.
    }
    
    fileprivate func setup() {
        errorLabel.alpha = 0
        
        firstNameTextField.addTarget(self, action: #selector(textFieldDidStartEditing), for: .editingDidBegin)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidStartEditing), for: .editingDidBegin)
        firstNameTextField.addTarget(self, action: #selector(textFieldDidStopEditing), for: .editingDidEnd)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidStopEditing), for: .editingDidEnd)
        
        firstNameTextField.addBottomBorder()
        lastNameTextField.addBottomBorder()
    }
    
    func showErrorLabel(_ errorMessage: String) {
        errorLabel.text = errorMessage
        errorLabel.alpha = 1
    }
    
    @objc private func textFieldDidStartEditing(_ sender: UnderlinedTextField) {
        sender.startEditing()
    }
    
    @objc private func textFieldDidStopEditing(_ sender: UnderlinedTextField) {
        sender.stopEditing()
    }
    
    @IBAction func nextClick(_ sender: Any) {
        
        guard let fName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            showErrorLabel("Please provide a firstname")
            return
        }
        
        guard let lName = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            showErrorLabel("Please provide a lastname")
            return
        }
        
        if (fName == "" || lName == "") {
            showErrorLabel("One or more fields are empty")
            return
        }
        
        self.firstname = fName
        self.lastname = lName
        
        performSegue(withIdentifier: "next", sender: self)
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dest = segue.destination as? EmailRegisterViewController {
            dest.firstname = self.firstname
            dest.lastname = self.lastname
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
