//
//  InputViewController.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 9/13/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class InputViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var navbar: UINavigationBar!

    @IBOutlet weak var bottomToolbarConstraintValue: NSLayoutConstraint!
    
    
    var initialBottomToolbarConstraintValue: CGFloat?
    var context: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.font = UIFont(name: "Georgia", size: 15.0)

        self.initialBottomToolbarConstraintValue = bottomToolbarConstraintValue.constant
        
        enableKeyboardHideOnTap()
        
        loadContext()
        
        // Do any additional setup after loading the view.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    
    func enableKeyboardHideOnTap() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InputViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InputViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InputViewController.hideKeyboard))
        
        self.view.addGestureRecognizer(tap)
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animateWithDuration(duration) { () -> Void in
            
            self.bottomToolbarConstraintValue.constant = keyboardFrame.size.height + 5
            
            self.view.layoutIfNeeded()
            
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animateWithDuration(duration) { () -> Void in
            
            self.bottomToolbarConstraintValue.constant = self.initialBottomToolbarConstraintValue!
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    func loadContext() {
        navbar.topItem?.title = context
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func dismissModal(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // Text view related
    
    let tagsAttribute = [NSForegroundColorAttributeName: UIColor.blueColor()]
    let fontAttribute = [NSFontAttributeName: UIFont(name: "Georgia", size: 15.0)]
    
    func textViewDidChange(textView: UITextView) {
        if let lastCharacter = textView.text.characters.last {
            if (lastCharacter == " "){
                let text = textView.text
                let textCharacters = text.characters
                for index in (textCharacters.count-1).stride(through: 0, by: -1) {
                    if (text[text.startIndex.advancedBy(index)] == " ") {
                        if (index != text.characters.count - 1 && text[text.startIndex.advancedBy(index+1)] == "@") {
                            let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: text)
                            let range: NSRange = NSRange(location: index+1, length: (textCharacters.count-2) - index)
                            attributedText.addAttributes(tagsAttribute, range: range)
                            attributedText.addAttributes([NSFontAttributeName: UIFont(name: "Georgia", size: 15.0)!], range: NSRange(location: 0, length: textCharacters.count-1))
                            textView.attributedText = attributedText
                            break
                        }
                    }
                }
                
                
                
                
            }
        }
    }
    

}
