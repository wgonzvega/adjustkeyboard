//
//  ViewController.swift
//  testKeyboardHeight
//
//  Created by Walter Gonzalez on 1/3/18.
//  Copyright © 2018 Walter Gonzalez. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
  
    
    
    
    @IBOutlet weak var thirdTextOutlet: UITextField!
    @IBOutlet weak var topTextOutlet: UITextField!
    @IBOutlet weak var midTextOutlet: UITextField!
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)*/
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

  
    
   

    
    // keyboard action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    // hide the keyboard when the return key is pressed.  first we need a new class declaration at the top of this code (in the class section) called UITextFieldDelegate, write this code, then on the view drag control/click the edit field to the viewcontroller icon at the top of the window to link the delegation
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
        
        /*
            This example code is for adjusting text views. If you want it to apply to a regular scroll view, just take out the last two lines - they are in there so that the text view readjusts itself so the user doesn't lose their place while editing.
        */
        
        //let selectedRange = yourTextView.selectedRange
        //yourTextView.scrollRangeToVisible(selectedRange)
    }
}

