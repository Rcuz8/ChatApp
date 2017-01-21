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
        
        myChatsLabel.layer.borderColor = UIColor.white.cgColor
        
        myChatsLabel.layer.borderWidth = 4
        
        newChatButton.layer.cornerRadius = 6
        
        newChatButton.layer.borderColor = UIColor.black.cgColor
        
        newChatButton.layer.borderWidth = 4
        
        if let id = FIRAuth.auth()?.currentUser?.uid {
            
            self.firebase.child("Users").child(id).child("CHATS").observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                if let snapVal = snapshot.value as? [String: AnyObject] {
                    for chat in snapVal {
                        
                      //  let chatAsObject = chat
                        let chatString = chat.key
                        self.listOfIDs.append(chatString)
                        self.firebase.child("Chats").child(chatString).child("MEMBERS").observeSingleEvent(of: .value, with: { (snap: FIRDataSnapshot) in
                            if let snapV = snap.value as? [String: AnyObject] {
                            if snap.childrenCount > 1 {
                                for member in snapV {
                                    let userID = member.key
                                    // let userID = member.value["ID"] as! String
                                    if id != userID {
                                        if let name = member.value["NAME"] as? String {
                                        self.listOfChatNames.append(name)
                                        }
                                    }
                                }
                            }
                            self.tableView.reloadData()
                            }
                        })
                    }
                }
                /*      OLDDDDDD
                if snapshot.hasChildren() {
                    
                    for chat in snapshot.children {
                        
                        let chatAsObject = chat as AnyObject
                        let chatString = chatAsObject.key!
                       self.listOfIDs.append(chatAsObject.key!)
                        self.firebase.child("Chats").child(chatString).child("MEMBERS").observeSingleEvent(of: .value, with: { (snap: FIRDataSnapshot) in
                            
                            if snap.childrenCount > 1 {
                                for member in snap.children {
                                   let userID = (member as AnyObject).key!
                                   // let userID = member.value["ID"] as! String
                                    if id != userID {
                                        let name = (member as AnyObject).value!["NAME"] as! String
                                        self.listOfChatNames.append(name)
                                    }
                                }
                            }
                            self.tableView.reloadData()
                        })
                    }
                    
                }
                */
            })
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "myChatsCell") as! ChatTableViewCell
        cell.name.text = listOfChatNames[indexPath.row]
        cell.contentView.layer.cornerRadius = 5
        cell.viewWithTag(0)?.layer.cornerRadius = 5
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let activeID = listOfIDs[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Messages") as! MessageViewController
        vc.chatID = activeID
        
        vc.otherMemberName = listOfChatNames[indexPath.row]
        self.present(vc, animated: true, completion: nil)
        
        
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
