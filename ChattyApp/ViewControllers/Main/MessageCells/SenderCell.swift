//
//  SenderCell.swift
//  ChattyApp
//
//  Created by Zoli Nahoczki on 10/14/20.
//

import UIKit

class SenderCell: UITableViewCell {

    let messageLabel = UILabel()
    let bubbleBackground = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(bubbleBackground)
        bubbleBackground.backgroundColor = .systemPurple
        bubbleBackground.layer.cornerRadius = 10
        bubbleBackground.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .white
        //messageLabel.text = "FUCK"
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        let constraints = [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            bubbleBackground.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            bubbleBackground.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            bubbleBackground.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleBackground.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16)
            
        
        ]
        
        print("generated")
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
