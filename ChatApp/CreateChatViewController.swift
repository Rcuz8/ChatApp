//
//  CreateChatViewController.swift
//  ChatApp
//
//  Created by Ryan Cocuzzo on 8/21/16.
//  Copyright © 2016 rcocuzzo8. All rights reserved.
//

import UIKit
import Firebase

class CreateChatViewController: UIViewController {
    
    let firebase = FIRDatabase.database().reference()
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var checkLabel: UILabel!
    
    @IBOutlet weak var createChatButton: UIButton!
    // Active Name is the name of the user that matches the input in the emailfield
    
    var activeName: String!
    var activeID: String!
    var activeEmail: String!
    
    var isValid: Bool!
    
    
    @IBOutlet weak var enterLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        activeEmail = ""
        activeName = ""
        activeID = ""
        isValid = false
        
        enterLabel.layer.cornerRadius = 6
        
        enterLabel.layer.borderColor = UIColor.blackColor().CGColor
        
        enterLabel.layer.borderWidth = 4
        
        createChatButton.layer.cornerRadius = 6
        
        createChatButton.layer.borderColor = UIColor.blackColor().CGColor
        
        createChatButton.layer.borderWidth = 4
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editingChanged(sender: AnyObject) {
        
        if let text = emailField.text {
            
           // var found: Bool! // represents whether or not we have found the matching user
            var found = false
            
            self.firebase.child("Users").observeSingleEventOfType(.Value, withBlock: { (snap: FIRDataSnapshot) in
                
                for child in snap.children {
                    if child.hasChild("EMAIL") {
                        let email =  child.value!["EMAIL"] as! String
                        
                        if email == text { // User matches the User's email entered into the textfield
                            found = true
                            let fname = child.value!["FIRST_NAME"] as! String
                            let lname = child.value!["LAST_NAME"] as! String
                            self.activeName = "\(fname) \(lname)"
                            
                            self.activeID = child.key!
                            
                        }
                        
                    }
                }
                
            })
            
            if found { // means that user has been found
                self.checkLabel.text = "✅"
                self.isValid = true
            } else {
                self.checkLabel.text = "❌"
                self.isValid = false
            }
            
            self.activeEmail = text
            
        }
        
    }
   
    
    @IBAction func createChat(sender: AnyObject) {
        
        
        if let valid = self.isValid {
            
            if valid {
                let chadID = self.firebase.childByAutoId().key
                
                if let id = FIRAuth.auth()?.currentUser?.uid {
                    
                    // Get User info
                    
                    self.firebase.child("Users").child("\(id)").observeSingleEventOfType(.Value, withBlock: { (snap: FIRDataSnapshot) in
                        
                        let myFirstName = snap.value!["FIRST_NAME"] as! String
                        let myLastName = snap.value!["LAST_NAME"] as! String
                        let myEmail = snap.value!["EMAIL"] as! String
                        
                        self.firebase.child("Chats").child(chadID).child("MEMBERS").child(id).child("NAME").setValue("\(myFirstName) \(myLastName)")
                        
                        self.firebase.child("Chats").child(chadID).child("MEMBERS").child(self.activeID).child("NAME").setValue(self.activeName)
                        
                        self.firebase.child("Chats").child(chadID).child("MEMBERS").child(id).child("EMAIL").setValue(myEmail)
                        
                        self.firebase.child("Chats").child(chadID).child("MEMBERS").child(self.activeID).child("EMAIL").setValue(self.activeEmail)
                        
                        self.firebase.child("Users").child(id).child("CHATS").child(chadID).setValue("ACTIVE")
                        
                        self.firebase.child("Users").child(self.activeID).child("CHATS").child(chadID).setValue("ACTIVE")
                        
                        // Display Successful Message
                        self.displayMessage(true)
                    })
                    
                }
            } else {
                // Display Unsuccessful Message
                self.displayMessage(false)
            }
            
        }
        
    }
    
    func displayMessage(successful: Bool) {
        
        if successful {
            let ac = UIAlertController(title: "Chat Created!", message: "Your new chat has been created!", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Ok", style: .Default, handler: { (UIAlertAction) in
                // Switch view
                self.goTo("Chats")
            })
            ac.addAction(ok)
            self.presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Error in email field!", message: "Please re-enter the email address!", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Ok", style: .Default, handler: { (UIAlertAction) in
              
            })
            ac.addAction(ok)
            self.presentViewController(ac, animated: true, completion: nil)
        }
        
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
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
