//
//  ViewController.swift
//  ChatApp
//
//  Created by Ryan Cocuzzo on 8/17/16.
//  Copyright © 2016 rcocuzzo8. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    let firebase = FIRDatabase.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 6
        createAccountButton.layer.cornerRadius = 6
        
        loginButton.layer.borderColor = UIColor.blackColor().CGColor
        createAccountButton.layer.borderColor = UIColor.blackColor().CGColor
        
        loginButton.layer.borderWidth = 4
        createAccountButton.layer.borderWidth = 4
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func login(sender: AnyObject) {
        
        if emailField.text != nil && emailField.text != "" && passField.text != nil && passField.text != "" {
        
        FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passField.text!, completion: { (user: FIRUser?, error: NSError?) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("User Signed in!")
                print("User ID: \(user!.uid)")
                self.goTo("Chats")
            }
        })
        } else {
            self.displayMessage("Invalid Information", title: "Please Try Again!")
        }
    }
    
    func displayMessage(msg: String, title: String) -> Void {
        let ac = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        ac.addAction(ok)
        self.presentViewController(ac, animated: true, completion: nil)
    }
    
    func goTo(viewController: String) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier(viewController)
        if vc != nil {
            self.presentViewController(vc!, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

