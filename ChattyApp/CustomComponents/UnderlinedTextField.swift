//
//  UnderlinedTextField.swift
//  ChattyApp
//
//  Created by Zoli Nahoczki on 10/13/20.
//

import UIKit

class UnderlinedTextField: UITextField {
    
    var bottomLine: CALayer!
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
      
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
      
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func addBottomBorder() {
        
        self.layoutIfNeeded()
        
        let bottomLineDeselect = CALayer()
        bottomLineDeselect.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.width, height: 1)
        bottomLineDeselect.backgroundColor = UIColor.lightGray.cgColor
        layer.addSublayer(bottomLineDeselect)
        
        
        bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: 0, height: 1)
        bottomLine.backgroundColor = UIColor.systemPurple.cgColor
        borderStyle = .none
        
        layer.addSublayer(bottomLine)
        
        
        
    }
    
    func startEditing() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 2, options: .curveEaseIn) {
            self.bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        } completion: { (bool) in
            print("done")
        }
        
        print("editing")
    }
    
    func stopEditing() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 2, options: .curveEaseOut) {
            self.bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: 0, height: 1)
        } completion: { (bool) in
            print("done")
        }
    }
    
}
