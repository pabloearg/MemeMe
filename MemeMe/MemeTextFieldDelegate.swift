//
//  MemeTextFieldDelegate.swift
//  pickImages
//
//  Created by Pablo Arguimbau on 24/05/2021.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
        var isFirstTime = true
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isFirstTime {
            textField.text = ""
        }
        self.isFirstTime = false
//        if textField.text!.isEmpty {
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
}

