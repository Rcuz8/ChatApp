//
//  CreateAccountViewController.swift
//  ChatApp
//
//  Created by Ryan Cocuzzo on 8/18/16.
//  Copyright © 2016 rcocuzzo8. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var createAccountButton: UIButton!
    
    let firebase = FIRDatabase.database().reference()
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var firstNamefield: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var confirmField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAccountButton.layer.cornerRadius = 6
       
        createAccountButton.layer.borderColor = UIColor.blackColor().CGColor
        
        createAccountButton.layer.borderWidth = 4

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        if checkFields() {
            // Create an Account
            FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!, completion: { (user: FIRUser?, error: NSError?) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    self.firebase.child("Users").child(user!.uid).child("FIRST_NAME").setValue(self.firstNamefield.text!)
                    self.firebase.child("Users").child(user!.uid).child("LAST_NAME").setValue(self.lastNameField.text!)
                    self.firebase.child("Users").child(user!.uid).child("EMAIL").setValue(self.emailField.text!)
                    self.firebase.child("Users").child(user!.uid).child("PASSWORD").setValue(self.passwordField.text!)
                    
                    // Call the goTo method
                    
                    self.displaySuccessMessage("You can now use the Chat App!", title: "Welcome, \(self.firstNamefield.text!)")
                    
                    
                  
                    
                }
            })
        }
    }
    
    func checkFields() -> Bool {
        if emailField.text != nil && firstNamefield.text != nil && lastNameField.text != nil && passwordField.text != nil && confirmField.text != nil && emailField.text != "" && firstNamefield.text != "" && lastNameField.text != "" && passwordField.text != "" && confirmField.text != "" && confirmField.text == passwordField.text {
            return true
        } else {
            return false
        }
    }

    func goTo(viewController: String) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier(viewController)
        if vc != nil {
        self.presentViewController(vc!, animated: true, completion: nil)
        }
    }
  
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    
    func displayMessage(msg: String, title: String) -> Void {
        let ac = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        ac.addAction(ok)
        self.presentViewController(ac, animated: true, completion: nil)
    }
    
    func displaySuccessMessage(msg: String, title: String) -> Void {
        let ac = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "Ok", style: .Default) {
            (action: UIAlertAction) in
            self.goTo("login")
        }
        ac.addAction(ok)
        self.presentViewController(ac, animated: true, completion: nil)
    }
    
    
}
