//
//  textFieldsDelegate.swift
//  MemeMe
//
//  Created by Asma  on 1/3/21.
//

import Foundation
import UIKit

class textFieldDelegate:NSObject,UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Clear default text
        if(textField.text=="TOP" || textField.text=="BOTTOM"){
            textField.text=""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
}
