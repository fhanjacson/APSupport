//
//  ChatDetail.swift
//  APSupport
//
//  Created by localadmin on 18/05/2019.
//  Copyright © 2019 Fhan Jacson. All rights reserved.
//

import UIKit
import Firebase

class ChatDetail: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var textMessage: UITextField!
    var selectedChatCategoryString = ""
    var ChatObject = [NSDictionary]()
    //var items: [String] = ["Swift1", "Swift2", "Swift3"]
    var user = Profile()
    
    
    @IBOutlet weak var ChatDetail_Table: UITableView!
    @IBAction func buttonSendMessage_Click(_ sender: Any) {
        if textMessage.text?.isEmpty ?? true {
            
        } else {
        createNewMessage(message: textMessage.text!, username: user.Username, fullname: user.FullName)
        }
    }
    
    func createNewMessage(message: String, username: String, fullname: String) {
        let db = Firestore.firestore()
        let data = [
            "message" : message,
            "username" : username,
            "timestamp" : Timestamp(date: Date()),
            "fullname" : fullname] as [String : Any]
        
        db.collection("OnlineChat").document("General").collection("messages").document().setData(data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
    }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("#ChatDetail")
        print("Chat Topic: \(selectedChatCategoryString)")
        
        
        self.ChatDetail_Table.register(UITableViewCell.self, forCellReuseIdentifier: "ChatDetailCell")
        getChatDetail()
        print("ChatObject: \(ChatObject)")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let db = Firestore.firestore()
        db.collection("OnlineChat").document(selectedChatCategoryString).collection("messages").addSnapshotListener {
            (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.ChatObject.append(document.data() as NSDictionary)
                }
                print(self.ChatObject)
                self.ChatDetail_Table.reloadData()
                
                
            }
        }
        
        
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        ChatDetail_Table.reloadData()
        
    }
    
    func getChatDetail() {
        let db = Firestore.firestore()
        db.collection("OnlineChat").document(selectedChatCategoryString).collection("messages").addSnapshotListener {
            (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.ChatObject.removeAll()
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.ChatObject.append(document.data() as NSDictionary)
                }
                self.ChatDetail_Table.reloadData()
                
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

      func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

      func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Chat: " + selectedChatCategoryString
    }
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ChatObject.count
        //return self.items.count
    }

    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatDetailCell", for: indexPath)

        cell.textLabel?.text = ChatObject[indexPath.item]["message"] as? String
        // Configure the cell...
        //cell.textLabel?.text = self.items[indexPath.item]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected Index: \(self.ChatObject[indexPath.item])")
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
