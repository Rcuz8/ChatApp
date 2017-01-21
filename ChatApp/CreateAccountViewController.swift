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
       
        createAccountButton.layer.borderColor = UIColor.black.cgColor
        
        createAccountButton.layer.borderWidth = 4

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccount(_ sender: AnyObject) {
        if checkFields() {
            // Create an Account
            
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user: FIRUser?, error:Error?) in
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

    func goTo(_ viewController: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: viewController)
        if vc != nil {
        self.present(vc!, animated: true, completion: nil)
        }
    }
  
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    
    func displayMessage(_ msg: String, title: String) -> Void {
        let ac = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        ac.addAction(ok)
        self.present(ac, animated: true, completion: nil)
    }
    
    func displaySuccessMessage(_ msg: String, title: String) -> Void {
        let ac = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) {
            (action: UIAlertAction) in
            self.goTo("login")
        }
        ac.addAction(ok)
        self.present(ac, animated: true, completion: nil)
    }
    
    
}
