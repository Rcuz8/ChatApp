//
//  MyChatsViewController.swift
//  ChatApp
//
//  Created by Ryan Cocuzzo on 8/18/16.
//  Copyright © 2016 rcocuzzo8. All rights reserved.
//

import UIKit
import Firebase
import QuartzCore

class MyChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var listOfChatNames = [String] ()
    
    var listOfIDs = [String] ()
    
    let firebase = FIRDatabase.database().reference()
    
    @IBOutlet weak var myChatsLabel: UILabel!
    
    @IBOutlet weak var newChatButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get User ID, Access User Chats (if they exist), Access the other persons name
        
        myChatsLabel.layer.cornerRadius = 6
        
        myChatsLabel.layer.borderColor = UIColor.whiteColor().CGColor
        
        myChatsLabel.layer.borderWidth = 4
        
        newChatButton.layer.cornerRadius = 6
        
        newChatButton.layer.borderColor = UIColor.blackColor().CGColor
        
        newChatButton.layer.borderWidth = 4
        
        if let id = FIRAuth.auth()?.currentUser?.uid {
            
            self.firebase.child("Users").child(id).child("CHATS").observeSingleEventOfType(.Value, withBlock: { (snapshot: FIRDataSnapshot) in
                if snapshot.hasChildren() {
                    
                    for chat in snapshot.children {
                        
                        let chatAsObject = chat as! AnyObject
                        let chatString = chatAsObject.key!
                       self.listOfIDs.append(chatAsObject.key!)
                        self.firebase.child("Chats").child(chatString).child("MEMBERS").observeSingleEventOfType(.Value, withBlock: { (snap: FIRDataSnapshot) in
                            if snap.childrenCount > 1 {
                                for member in snap.children {
                                   let userID = member.key!
                                   // let userID = member.value["ID"] as! String
                                    if id != userID {
                                        let name = member.value!["NAME"] as! String
                                        self.listOfChatNames.append(name)
                                    }
                                }
                            }
                            self.tableView.reloadData()
                        })
                    }
                    
                }
            })
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("myChatsCell") as! ChatTableViewCell
        cell.name.text = listOfChatNames[indexPath.row]
        cell.contentView.layer.cornerRadius = 5
        cell.viewWithTag(0)?.layer.cornerRadius = 5
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let activeID = listOfIDs[indexPath.row]
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("Messages") as! MessageViewController
        vc.chatID = activeID
        
        vc.otherMemberName = listOfChatNames[indexPath.row]
        self.presentViewController(vc, animated: true, completion: nil)
        
        
      
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfChatNames.count
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
