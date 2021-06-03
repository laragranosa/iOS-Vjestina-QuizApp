//
//  Design.swift
//  QuizApp
//
//  Created by Lara on 30/05/2021.
//  Copyright © 2021 Lara. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class customDesign {
    
    let mycolor = UIColor(red: 0, green: 0.11, blue: 0.28, alpha: 1)
    
    func styleButton(button: UIButton, title: String, width: Float) -> UIButton {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name:"ArialRoundedMTBold", size: 15.0)
        button.setTitleColor(mycolor, for: .normal)
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        return button
    }
    
    func buildTextField(string: String) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        //textField.widthAnchor.constraint(equalToConstant: 340).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.attributedPlaceholder = NSAttributedString(string: string,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.clipsToBounds = true
        textField.textColor = .white
        textField.layer.cornerRadius = 20
        textField.backgroundColor = UIColor(white: 1, alpha: 0.5)
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10, height: 0))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        return textField
    }

}
