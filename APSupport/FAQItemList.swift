//
//  FAQItemList.swift
//  APSupport
//
//  Created by localadmin on 18/05/2019.
//  Copyright © 2019 Fhan Jacson. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase

class FAQItemList: UITableViewController {
    @IBOutlet var FAQItemList_Table: UITableView!
    
    var selectedFAQCategory: String?
    var selectedFAQItemListIndex: Int?
    var FAQItemListDict: [NSDictionary]?
    var user = Profile()
    var selectedFAQCategoryItem: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("")
        print("#FAQItemList")
        FAQItemList_Table.dataSource = self
        FAQItemList_Table.delegate = self
        FAQItemList_Table.register(UITableViewCell.self, forCellReuseIdentifier: "FAQItemListCell")
        print("1st article: \(FAQItemListDict![0]["title"])")
        
        
        
        print("end")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewDidAppear(_ animated: Bool) {
        FAQItemList_Table.reloadData()
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return FAQItemList!.count
        return FAQItemListDict!.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return selectedFAQCategory
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQItemListCell", for: indexPath)
        cell.textLabel?.text = FAQItemListDict![indexPath.item]["title"] as? String
        cell.textLabel?.numberOfLines = 0;
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Selected: \(FAQItemListDict![indexPath.item]["title"])")
        selectedFAQItemListIndex = indexPath.item
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toFAQItemDetail", sender: self)
        
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
        if segue.identifier == "toFAQItemDetail" {
            if let FAQItemDetail = segue.destination as? FAQItemDetail {
                    FAQItemDetail.selectedFAQItemListIndex = selectedFAQItemListIndex
                    FAQItemDetail.FAQItemListDict = FAQItemListDict
                    FAQItemDetail.user = user
                FAQItemDetail.selectedFAQCategoryItem = selectedFAQCategoryItem
            }
        }
            
        
    }
    

}
