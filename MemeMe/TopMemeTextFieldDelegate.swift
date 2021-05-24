//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Pablo Arguimbau on 24/05/2021.
//

import Foundation
import UIKit

class TopMemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    let TOP_TEXT = "TOP"
    var isFirstTime = true
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == TOP_TEXT {
            textField.text = ""
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = TOP_TEXT
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
}

