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
        
        loginButton.layer.borderColor = UIColor.black.cgColor
        createAccountButton.layer.borderColor = UIColor.black.cgColor
        
        loginButton.layer.borderWidth = 4
        createAccountButton.layer.borderWidth = 4
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func login(_ sender: AnyObject) {
        
        if emailField.text != nil && emailField.text != "" && passField.text != nil && passField.text != "" {
        
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passField.text!, completion: { (user: FIRUser?, error: Error?) in
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
    
    func displayMessage(_ msg: String, title: String) -> Void {
        let ac = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        ac.addAction(ok)
        self.present(ac, animated: true, completion: nil)
    }
    
    func goTo(_ viewController: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: viewController)
        if vc != nil {
            self.present(vc!, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

