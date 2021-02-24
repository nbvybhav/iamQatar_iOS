//
//  File.swift
//  JobServiceApp
//
//  Created by Alisons on 27/09/16.
//  Copyright © 2016 Alisons Infomatics. All rights reserved.
//

import Foundation

open class HelperValidate{
    
    // Email-validation
    class func isValidEmail(_ testStr:String) -> Bool {
       // print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    // Phone number validation
    class  func isValidPhone(_ value: String) -> Bool {
        
        if value.count != 8 { return false }
        
        let PHONE_REGEX = "^(?:[0-9]\\d*)(?:\\.\\d*)?$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }

   class func containsOnlyLetters(_ input: String) -> Bool {

        var Result = Bool()
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ")
        if input.rangeOfCharacter(from: characterset.inverted) != nil {
            Result =  false
        }else
        {
            Result = true
        }
        return Result
    }
    
    class func containsOnlyZero(_ input: String) -> Bool {
        
        var Result = Bool()
        let characterset = CharacterSet(charactersIn: "0")
        if input.rangeOfCharacter(from: characterset.inverted) != nil {
            Result =  false
        }else
        {
            Result = true
        }
        return Result
    }
    
    class func containsOnlyNumbers(_ input: String) -> Bool {
        var Result = Bool()
        let characterset = CharacterSet(charactersIn: "1234567890")
        if input.rangeOfCharacter(from: characterset.inverted) != nil {
            Result =  false
        } else {
            Result = true
        }
        
        return Result
    }
    
    class func containsOnlyLettersandSpaces(_ input: String) -> Bool {
       
        var Result = Bool()
        let newInput = input.replacingOccurrences(of: " ", with: "")
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ")
        if newInput.rangeOfCharacter(from: characterset.inverted) != nil {
            Result =  false
        }else {
            Result = true
        }
        return Result
    }

    
    class func isEmpty(_ TestString:String) -> Bool{
        
        if (TestString == "") {
            return true
        }else {
            return false
        }
    }

    

}
