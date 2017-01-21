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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var nameLabel: UILabel!
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "messageCell") as! MessageTableViewCell 
        cell.message.numberOfLines = 0
        
        cell.message.text = listOfMessages[indexPath.row]
        cell.message.layer.cornerRadius = 5
        let aTag = "\(listOfNames[indexPath.row]), \(listOfDateTimes[indexPath.row])"
        cell.messageTag.text = aTag
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            
            func initMessages() {
            self.firebase.child("Chats").child(self.chatID).child("MESSAGES").observeSingleEvent(of: .value, with: { (snap: FIRDataSnapshot) in
                //   print("Something Observed!")
                
                   let snapChildCount = Int(snap.childrenCount)
                  var currentChildNum = 0
                for child in snap.children  {
                       currentChildNum += 1
                      if currentChildNum != snapChildCount {
                    let snapChildCount = Int(snap.childrenCount)
                    var currentChildNum = 0
                    let childSnap = child as! FIRDataSnapshot
                    if let snapVal = childSnap.value as? [String: AnyObject] { // snapVal for individual child
                        currentChildNum += 1
                        if currentChildNum != snapChildCount {
                        if snapVal["ID"] != nil {
                            if let uid = snapVal["ID"] as? String {
                                print("Got ID")
                                if let name = snapVal["NAME"] as? String {
                                    print("Got NAME")
                                    if let dateTime = snapVal["DATETIME"] as? String {
                                        print("Got DateTime")
                                        if let msg = snapVal["MESSAGE"] as? String {
                                            print("Got Message")
                                            print("Appending..")
                                            self.listOfIDs.append(uid)
                                            self.listOfNames.append(name)
                                            self.listOfMessages.append(msg)
                                            self.listOfDateTimes.append(dateTime)
                                        }
                                    }
                                }
                            }
                        }
                        }
                             }
                    }
                }
                self.createObserver()
            })
                
        } // End Func
            
            /*
            self.firebase.child("Chats").child(self.chatID).child("MESSAGES").observeSingleEvent(of: .value, with: { (snap: FIRDataSnapshot) in
                if let snapVal = snap.value as? [String: AnyObject] {
                for message in snapVal {
                    //NEWWWWW
                    if message.value["ID"] != nil && message.value["NAME"]  != nil && message.value["DATETIME"]  != nil && message.value["MESSAGE"]  != nil {
                        if let uid = message.value["ID"] as? String {
                            if let name = message.value["NAME"] as? String {
                                if let dateTime = message.value["DATETIME"] as? String {
                                    if let msg = message.value["MESSAGE"] as? String {
                                        self.listOfIDs.append(uid)
                                        self.listOfNames.append(name)
                                        self.listOfMessages.append(msg)
                                        self.listOfDateTimes.append(dateTime)
                                    }
                                }
                            }
                        }
                    }
                    */
                    //END NEWWWWW
                    
                    /*
                    if (message as AnyObject).hasChild("ID") && (message as AnyObject).hasChild("NAME") && (message as AnyObject).hasChild("DATETIME") && (message as AnyObject).hasChild("MESSAGE") {
                 
                    let uid = (message as AnyObject).value!["ID"] as! String
                    let name = (message as AnyObject).value!["NAME"] as! String
                    let dateTime = (message as AnyObject).value!["DATETIME"] as! String
                    let message = (message as AnyObject).value!["MESSAGE"] as! String
                    
                    self.listOfIDs.append(uid)
                    self.listOfNames.append(name)
                    self.listOfMessages.append(message)
                    self.listOfDateTimes.append(dateTime)
                   
                }
             */
            
            
            initMessages()                 // Mutually Exclusive
            //  self.createObserver()                // Mutually Exclusive
            self.tableView.reloadData()
            // Scroll to the bottom of the Table
            self.scrollToBottomOfTable()
                }
        
            }
          //  })
            
           
        
        
    



        // Do any additional setup after loading the view.
    
    
    func createObserver() {
        
        self.firebase.child("Chats").child(chatID).child("MESSAGES").observe(.value, with: { (snap: FIRDataSnapshot) in
            print("Something Observed!")
            
            let snapChildCount = Int(snap.childrenCount)
            var currentChildNum = 0
            for child in snap.children  {
                currentChildNum += 1
                if currentChildNum == snapChildCount {
                let childSnap = child as! FIRDataSnapshot
                if let snapVal = childSnap.value as? [String: AnyObject] { // snapVal for individual child
                if snapVal["ID"] != nil {
                    if let uid = snapVal["ID"] as? String {
                        print("Got ID")
                        if let name = snapVal["NAME"] as? String {
                            print("Got NAME")
                            if let dateTime = snapVal["DATETIME"] as? String {
                                print("Got DateTime")
                                if let msg = snapVal["MESSAGE"] as? String {
                                    
                                    if self.listOfDateTimes != nil && self.listOfDateTimes.count > 0 {
                                        let dtlCount:Int = self.listOfDateTimes.count-1
                                        let otherDT = self.listOfDateTimes[dtlCount]
                                        let msgCount: Int = self.listOfMessages.count-1
                                        let otherMSG = self.listOfMessages[msgCount]
                                    if dateTime != otherDT { // Check if message time is same as last
                                    print("Got Message")
                                    print("Appending..")
                                    self.listOfIDs.append(uid)
                                    self.listOfNames.append(name)
                                    self.listOfMessages.append(msg)
                                    self.listOfDateTimes.append(dateTime)
                                    } else {
                                        print("DateTime: \(dateTime)\nOther DateTime: |\(otherDT)")
                                        print("Message: \(msg)\nOther Message: \(otherMSG)")
                                        }
                                    } else { // Just Append
                                        print("Got Message")
                                        print("Appending..")
                                        self.listOfIDs.append(uid)
                                        self.listOfNames.append(name)
                                        self.listOfMessages.append(msg)
                                        self.listOfDateTimes.append(dateTime)
                                    }
                                }
                            }
                        }
                    }
                }
                }
                }
            }
            
            /*
            if self.listOfMessages.count < Int(snap.childrenCount) {
                if let snapVal = snap.value as? [String: AnyObject] {
                    print(snapVal)
                    print("")
                    let key = (snapVal as! [String: AnyObject]).keys.first
                    print("KEYY: \(key)")
                        if let uid = snapVal["ID"] as? String {
                            print("Got ID")
                            if let name = snapVal["NAME"] as? String {
                                print("Got NAME")
                                if let dateTime = snapVal["DATETIME"] as? String {
                                    print("Got DateTime")
                                    if let msg = snapVal["MESSAGE"] as? String {
                                        print("Got Message")
                                        print("Appending..")
                                        self.listOfIDs.append(uid)
                                        self.listOfNames.append(name)
                                        self.listOfMessages.append(msg)
                                        self.listOfDateTimes.append(dateTime)
                                    }
                                }
                            }
                        }
                    }
        //    for message in snapVal {
                
                
              //  if Int(key) >= Int(snap.childrenCount) {  // Checks if message is LAST message sen
                
                    
                    //NEWWWWW
             //       if message.value["ID"] != nil && message.value["NAME"]  != nil && message.value["DATETIME"]  != nil && message.value["MESSAGE"]  !=
                //    }
                    //END NEWWWWW
                    
                    self.tableView.reloadData()
                    
                    // Scroll to the bottom of the Table
                    self.scrollToBottomOfTable()
                
            }
            */
            self.tableView.reloadData()
            
            // Scroll to the bottom of the Table
            self.scrollToBottomOfTable()
            
        
        })
        
    }
    
    @IBAction func sendMessage(_ sender: AnyObject) {
        
        if messageField.text != nil && messageField.text != "" {
            
            var childCount: Int!
            childCount = 0
            
            func saveToDatabase() {
                
                if let id = FIRAuth.auth()?.currentUser?.uid {
            
                    self.firebase.child("Users").child(id).observeSingleEvent(of: .value, with: { (snap: FIRDataSnapshot) in
                        if let snapVal = snap.value as? [String: AnyObject] {
                            let myFName = snapVal["FIRST_NAME"] as! String
                            let myLName = snapVal["LAST_NAME"] as! String
                            let myName = "\(myFName) \(myLName)"
                            let myID = snapVal["FIRST_NAME"] as! String
                        
                        /*
                        let myFName = snap.value!["FIRST_NAME"] as! String
                        let myLName = snap.value!["LAST_NAME"] as! String
                        let myName = "\(myFName) \(myLName)"
                        let myID = snap.value!["FIRST_NAME"] as! String
                        */
                        // Make a message with an ID 1 higher than the last message
                        
                        let messagePosition = childCount + 1
                        let autoID = FIRDatabase.database().reference().childByAutoId().key// as! String
                        self.firebase.child("Chats").child(self.chatID).child("MESSAGES").child(autoID).child("NAME").setValue(myName)
                        self.firebase.child("Chats").child(self.chatID).child("MESSAGES").child(autoID).child("ID").setValue(id)
                        self.firebase.child("Chats").child(self.chatID).child("MESSAGES").child(autoID).child("MESSAGE").setValue(self.messageField.text!)
                        
                        let date = Date()
                        
                        let formatter = DateFormatter()
                        
                        formatter.locale = Locale.current
                        
                        formatter.dateStyle = .short
                        formatter.timeStyle = DateFormatter.Style.long
                        
                        let dateString = formatter.string(from: date)
                        
                        self.firebase.child("Chats").child(self.chatID).child("MESSAGES").child(autoID).child("DATETIME").setValue(dateString)
                        
                        
                        
                        self.tableView.reloadData()
                        
                        if self.listOfMessages.count == 0 {
                            self.firebase.child("Chats").child(self.chatID).child("MESSAGES").removeAllObservers()
                            self.createObserver()
                        }
                        }
                    })
                    
                    
                }
            }
            
            
            // Getting amount of children in Chat
            
            self.firebase.child("Chats").child(chatID).child("MESSAGES").observeSingleEvent(of: .value, with: { (snap:FIRDataSnapshot) in
                childCount = Int(snap.childrenCount)
                saveToDatabase()
            })
            
            
            
        }
        
    }
    
    
    
    func runAfterDelay(_ delay: TimeInterval, block: @escaping ()->()) {
        let time = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: block)
    }
    
    func scrollToBottomOfTable(){
        
        let numberOfSections = self.tableView.numberOfSections
        let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
        runAfterDelay(0.2){
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
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
