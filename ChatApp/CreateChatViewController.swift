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
        
        enterLabel.layer.borderColor = UIColor.black.cgColor
        
        enterLabel.layer.borderWidth = 4
        
        createChatButton.layer.cornerRadius = 6
        
        createChatButton.layer.borderColor = UIColor.black.cgColor
        
        createChatButton.layer.borderWidth = 4
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editingChanged(_ sender: AnyObject) {
        
        
        var found = false
        
        
        if let text = emailField.text {
            
            if text == "" {
                print("Text is nil")
            } else {
           // var found: Bool! // represents whether or not we have found the matching user
            print("Not nil")
            
            self.firebase.child("Users").observeSingleEvent(of: .value, with: { (snap: FIRDataSnapshot) in
                // NEWWWW
                print("Not nil")
                if let snapVal = snap.value as? [String: AnyObject] {
                    print("Found SnapVal")
                    for child in snapVal as [String: AnyObject]{
                    print("\nChild info: \(child)")
                    
                //    if let childDict = child as? [String: AnyObject] {
                        print("\(child)")
                    if child.value["EMAIL"] != nil {
                        if let email = child.value["EMAIL"] as? String {
                            if email.lowercased() == text.lowercased() { // User matches the User's email entered into the textfield
                                if let fname = child.value["FIRST_NAME"] as? String {
                                    if let lname = child.value["LAST_NAME"] as? String {
                                        found = true
                                        let fname = child.value["FIRST_NAME"] as! String
                                        let lname = child.value["LAST_NAME"] as! String
                                        self.activeName = "\(fname) \(lname)"
                                        self.activeName = self.activeName!
                                        let key = child.key
                                        self.activeID = key
                                        self.activeID = self.activeID!
                                   //     self.activeEmail
                                        print("\n\n\n\n\n\nFOUND\n\n\n\n\n")
                                    }
                                }

                            }
                        }
                 //   }
                    }
                    // END NEWWWW
                    /*
                    if (child as AnyObject).hasChild("EMAIL") {
                        let email =  (child as AnyObject).value!["EMAIL"] as! String
                        
                        if email == text { // User matches the User's email entered into the textfield
                            found = true
                            let fname = (child as AnyObject).value!["FIRST_NAME"] as! String
                            let lname = (child as AnyObject).value!["LAST_NAME"] as! String
                            self.activeName = "\(fname) \(lname)"
                            
                            self.activeID = (child as AnyObject).key!
                            
                        }
                        
                    }
                    */
                }
                }
                if found { // means that user has been found
                    print("\n\nCheckLabel should update!\n\n")
                    self.checkLabel.text = "✅"
                    self.isValid = true
                } else {
                    self.checkLabel.text = "❌"
                    self.isValid = false
                }
                
                self.activeEmail = text
            })
        }
            
           
            
        }
        
    }
   
    
    @IBAction func createChat(_ sender: AnyObject) {
        
        
        if let valid = self.isValid {
            
            if valid {
                let chadID = self.firebase.childByAutoId().key
                
                if let id = FIRAuth.auth()?.currentUser?.uid {
                    
                    if let aName = self.activeName {
                        
                        if let aID = self.activeID {
                            
                            if let aEmail = self.activeEmail {
                    
                    
                    // Get User info
                    
                    self.firebase.child("Users").child("\(id)").observeSingleEvent(of: .value, with: { (snap: FIRDataSnapshot) in
                        if let snapVal = snap.value as? [String: AnyObject] {
                        let myFirstName = snapVal["FIRST_NAME"] as! String
                        let myLastName = snapVal["LAST_NAME"] as! String
                        let myEmail = snapVal["EMAIL"] as! String
                        print("My Credentials: \nFirst Name: \(myFirstName)\nLast Name: \(myLastName)\nEmail: \(myEmail)\nID: \(id)")
                        print("Other User's Credentials: \nName: \(self.activeName)\nEmail: \(self.activeEmail)\nID: \(self.activeID)")
                        self.firebase.child("Chats").child(chadID).child("MEMBERS").child(id).child("NAME").setValue("\(myFirstName) \(myLastName)")
                        
                        self.firebase.child("Chats").child(chadID).child("MEMBERS").child(aID).child("NAME").setValue(aName)
                        
                        self.firebase.child("Chats").child(chadID).child("MEMBERS").child(id).child("EMAIL").setValue(myEmail)
                        
                        self.firebase.child("Chats").child(chadID).child("MEMBERS").child(aID).child("EMAIL").setValue(aEmail)
                        
                        self.firebase.child("Users").child(id).child("CHATS").child(chadID).setValue("ACTIVE")
                        
                        self.firebase.child("Users").child(aID).child("CHATS").child(chadID).setValue("ACTIVE")
                        
                        // Display Successful Message
                        self.displayMessage(true)
                        }
                    })
                    
                    
                    // **
                    
                            }
                            
                        }
                        
                    }
                    
                    // **
                    
                }
            } else {
                // Display Unsuccessful Message
                self.displayMessage(false)
            }
            
        }
        
    }
    
    func displayMessage(_ successful: Bool) {
        
        if successful {
            let ac = UIAlertController(title: "Chat Created!", message: "Your new chat has been created!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                // Switch view
                self.goTo("Chats")
            })
            ac.addAction(ok)
            self.present(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Error in email field!", message: "Please re-enter the email address!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
              
            })
            ac.addAction(ok)
            self.present(ac, animated: true, completion: nil)
        }
        
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
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
