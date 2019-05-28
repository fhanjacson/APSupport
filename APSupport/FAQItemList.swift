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
    }

    override func viewDidAppear(_ animated: Bool) {
        FAQItemList_Table.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFAQItemListIndex = indexPath.item
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toFAQItemDetail", sender: self)
        
    }

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
