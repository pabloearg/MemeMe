//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Pablo Arguimbau on 24/05/2021.
//

import Foundation
import UIKit

class BottomMemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    var isFirstTime = true
    let BOTTOM_TEXT = "BOTTOM"
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == BOTTOM_TEXT {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = BOTTOM_TEXT
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
}

