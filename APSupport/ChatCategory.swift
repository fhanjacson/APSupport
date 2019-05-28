//
//  ChatCategory.swift
//  APSupport
//
//  Created by localadmin on 18/05/2019.
//  Copyright © 2019 Fhan Jacson. All rights reserved.
//

import UIKit
import Firebase

class ChatCategory: UITableViewController {
    
    @IBOutlet var ChatCategory_Table: UITableView!
    var ChatCategoryList = [String]()
    var tempvar = ""
    var selectedChatCategoryString = ""
    var user = Profile()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("")
        print("#ChatCategory")
        print("tempvar: \(tempvar)")
        print("ChatCategoryList: \(self.ChatCategoryList)")
        ChatCategory_Table.dataSource = self
        ChatCategory_Table.delegate = self
        ChatCategory_Table.register(UITableViewCell.self, forCellReuseIdentifier: "ChatCategoryCell")
        getChatCategory()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ChatCategory_Table.reloadData()
        print("ChatCategoryList: \(self.ChatCategoryList)")
    }
    
    func getChatCategory() {
        let db = Firestore.firestore()
        db.collection("OnlineChat").addSnapshotListener {
            (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.ChatCategoryList.removeAll()
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    self.ChatCategoryList.append(document.documentID as String)
                    print("ChatCategoryList: \(self.ChatCategoryList)")                    
                }
                self.ChatCategory_Table.reloadData()
                
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Chat Category"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.ChatCategoryList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCategoryCell", for: indexPath)
        
        cell.textLabel?.text = self.ChatCategoryList[indexPath.item]
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: \(ChatCategoryList[indexPath.item])")
        selectedChatCategoryString = ChatCategoryList[indexPath.item]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toChatDetail", sender: self)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if (segue.identifier == "toChatDetail") {
            if let ChatDetailController = segue.destination as? ChatDetail {
                ChatDetailController.selectedChatCategoryString = self.selectedChatCategoryString
                ChatDetailController.user = self.user
            }
        }
        
    }
    

}
