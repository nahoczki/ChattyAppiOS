//
//  CustomSpinnerButton.swift
//  CustomUIClasses
//
//  Created by Zoli Nahoczki on 9/27/20.
//

import UIKit

class CustomSpinnerButton: UIButton {
    
    var originalWidth: NSLayoutConstraint?
    let spinner = UIActivityIndicatorView()
    
    func startLoading() {
        layoutIfNeeded()
        //self.originalWidth = self.frame.width
        
         //Center spinner
        
        spinner.color = UIColor.white //Set color of spinner
        
        spinner.startAnimating()
        
        //self.addSubview(spinner)
        
        self.setTitle("", for: .normal) //Clear title
        
        originalWidth = self.widthAnchor.constraint(equalToConstant: self.bounds.height)
        
        UIView.animate(withDuration: 0.5) {
            
            self.layer.cornerRadius = self.bounds.height/2
            self.originalWidth!.isActive = true
            
            self.layer.layoutIfNeeded()
            
        } completion: { (ye) in
            self.spinner.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
            self.addSubview(self.spinner)
        }
        
    }
    
    func stopLoading() {
        guard let constraint = originalWidth else {
            print("Need to call start before stop")
            return
        }
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        constraint.constant = screenSize.width - (50 * 2)
        
        self.spinner.removeFromSuperview()
        
        UIView.animate(withDuration: 0.5) {
            self.layer.cornerRadius = 0
            
            self.layoutIfNeeded()
            
        } completion: { (true) in
            self.setTitle("Login", for: .normal)
        }
        
        
        
        
    }

}
