//
//  MessageViewController.swift
//  ChatApp
//
//  Created by Ryan Cocuzzo on 8/23/16.
//  Copyright © 2016 rcocuzzo8. All rights reserved.
//

import UIKit
import Firebase
import QuartzCore

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var nameLabel: UILabel!
   
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("messageCell") as! MessageTableViewCell 
        cell.message.numberOfLines = 0
        
        cell.message.text = listOfMessages[indexPath.row]
        cell.message.layer.cornerRadius = 5
        let aTag = "\(listOfNames[indexPath.row]), \(listOfDateTimes[indexPath.row])"
        cell.messageTag.text = aTag
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfMessages.count
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let firebase = FIRDatabase.database().reference()
    
    @IBOutlet weak var messageField: UITextField!
    
    // Contained inside of a message (Message content, ID of the author, Name of the Author, Date/Time stamp of when it was created
    
    var listOfMessages = [String] ()
    var listOfIDs = [String] ()
    var listOfDateTimes = [String] ()
    var listOfNames = [String] ()
    
    var chatID: String!
    
    var otherMemberName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.chatID)
        
        if otherMemberName != nil {
            self.nameLabel.text = otherMemberName
        }
        
       // Allows message cells to be resized
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 49
        
        if chatID != nil {
            
            // Set up each of the messages already present with a cell
            // Create an observer, which will create a new cell every someone speaks in the chat
            
            
            
            // CHANGE location of createObserver method
            
            self.firebase.child("Chats").child(chatID).child("MESSAGES").observeSingleEventOfType(.Value, withBlock: { (snap: FIRDataSnapshot) in
                for message in snap.children {
                    if message.hasChild("ID") && message.hasChild("NAME") && message.hasChild("DATETIME") && message.hasChild("MESSAGE") {
                 
                    let uid = message.value!["ID"] as! String
                    let name = message.value!["NAME"] as! String
                    let dateTime = message.value!["DATETIME"] as! String
                    let message = message.value!["MESSAGE"] as! String
                    
                    self.listOfIDs.append(uid)
                    self.listOfNames.append(name)
                    self.listOfMessages.append(message)
                    self.listOfDateTimes.append(dateTime)
                   
                }
             
                self.tableView.reloadData()
                // Scroll to the bottom of the Table
                    self.scrollToBottomOfTable()
                }
                self.createObserver()
            })
            
           
            
           
        }
       

        // Do any additional setup after loading the view.
    }
    
    func createObserver() {
        
        self.firebase.child("Chats").child(chatID).child("MESSAGES").observeEventType(.Value, withBlock: { (message: FIRDataSnapshot) in
            
            if self.listOfMessages.count < Int(message.childrenCount) {
            
            for child in message.children {
                
                let key = child.key!
                
                if Int(key) >= Int(message.childrenCount) {  // Checks if message is LAST message sen
                
                if child.hasChild("ID") && child.hasChild("NAME") && child.hasChild("DATETIME") && child.hasChild("MESSAGE") {
                    
                    let uid = child.value!["ID"] as! String
                    let name = child.value!["NAME"] as! String
                    let dateTime = child.value!["DATETIME"] as! String
                    let message = child.value!["MESSAGE"] as! String
                    
                    self.listOfIDs.append(uid)
                    self.listOfNames.append(name)
                    self.listOfMessages.append(message)
                    self.listOfDateTimes.append(dateTime)
                    
                    self.tableView.reloadData()
                    
                    // Scroll to the bottom of the Table
                    self.scrollToBottomOfTable()
                }
            }
                }
            }
            
        })
        
    }
    
    @IBAction func sendMessage(sender: AnyObject) {
        
        if messageField.text != nil && messageField.text != "" {
            
            var childCount: Int!
            childCount = 0
            
            func saveToDatabase() {
                
                if let id = FIRAuth.auth()?.currentUser?.uid {
            
                    self.firebase.child("Users").child(id).observeSingleEventOfType(.Value, withBlock: { (snap: FIRDataSnapshot) in
                        let myFName = snap.value!["FIRST_NAME"] as! String
                        let myLName = snap.value!["LAST_NAME"] as! String
                        let myName = "\(myFName) \(myLName)"
                        let myID = snap.value!["FIRST_NAME"] as! String // DELETE, CHANGE CHANGE
                        
                        // Make a message with an ID 1 higher than the last message
                        
                        let messagePosition = childCount + 1
                        
                        self.firebase.child("Chats").child(self.chatID).child("MESSAGES").child("\(messagePosition)").child("NAME").setValue(myName)
                            self.firebase.child("Chats").child(self.chatID).child("MESSAGES").child("\(messagePosition)").child("ID").setValue(id)
                        self.firebase.child("Chats").child(self.chatID).child("MESSAGES").child("\(messagePosition)").child("MESSAGE").setValue(self.messageField.text!)
                        
                        let date = NSDate()
                        
                        let formatter = NSDateFormatter()
                        
                        formatter.locale = NSLocale.currentLocale()
                        
                        formatter.dateStyle = .ShortStyle
                        formatter.timeStyle = .ShortStyle
                        
                        let dateString = formatter.stringFromDate(date)
                        
                        self.firebase.child("Chats").child(self.chatID).child("MESSAGES").child("\(messagePosition)").child("DATETIME").setValue(dateString)
                        
                        
                        
                        self.tableView.reloadData()
                        
                        if self.listOfMessages.count == 0 {
                            self.firebase.child("Chats").child(self.chatID).child("MESSAGES").removeAllObservers()
                            self.createObserver()
                        }
                        
                    })
                    
                    
                }
            }
            
            
            // Getting amount of children in Chat
            
            self.firebase.child("Chats").child(chatID).child("MESSAGES").observeSingleEventOfType(.Value, withBlock: { (snap:FIRDataSnapshot) in
                childCount = Int(snap.childrenCount)
                saveToDatabase()
            })
            
            
            
        }
        
    }
    
    
    
    func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }
    
    func scrollToBottomOfTable(){
        
        let numberOfSections = self.tableView.numberOfSections
        let numberOfRows = self.tableView.numberOfRowsInSection(numberOfSections-1)
        runAfterDelay(0.2){
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
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
