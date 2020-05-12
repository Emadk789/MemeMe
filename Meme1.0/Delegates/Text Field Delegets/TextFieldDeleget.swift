//
//  TextFieldDeleget.swift
//  Meme1.0
//
//  Created by Emad Albarnawi on 10/05/2020.
//  Copyright © 2020 Emad Albarnawi. All rights reserved.
//

import Foundation
import UIKit;

class TextFieldDeleget: NSObject, UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}

extension MemeMeController {
    
    // MARK: Configure meme text field
    func configureMemeTextField(_ textField: UITextField){
        textField.defaultTextAttributes = memeTextAttributes;
        textField.textAlignment = .center;
        
        //    MARK: Setting up the deleget for the text fields
        textField.delegate = textFieldDeleget;
    }
}
