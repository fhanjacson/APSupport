//
//  FavouriteFAQ.swift
//  APSupport
//
//  Created by Jacson on 24/05/2019.
//  Copyright © 2019 Fhan Jacson. All rights reserved.
//

import UIKit
import Firebase

class FavouriteFAQ: UITableViewController {

    @IBOutlet var FavouriteFAQ_Table: UITableView!
    
    
    var FavouriteFAQItems = [NSDictionary]()
    var FavouriteFAQCategory = [String]()
    var FavouriteFAQIndex = [Int]()
    var user = Profile()
    var FAQjson: NSDictionary = NSDictionary()
    var selectedFavIndex : Int?
    var selectedCategoryString: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("")
        print("#FavFAQ")
        FavouriteFAQ_Table.delegate = self
        FavouriteFAQ_Table.dataSource = self
        FavouriteFAQ_Table.register(UITableViewCell.self, forCellReuseIdentifier: "FavouriteFAQCell")
        print("FavFAQItems: \(FavouriteFAQItems)")
        getFavouriteFAQ()
        

    }
    
    func getFavouriteFAQ() {
        let db = Firestore.firestore()
        db.collection("Favourite").document(user.Username).collection("FAQ").addSnapshotListener {
            (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.FavouriteFAQItems.removeAll()
                var i = 0
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    self.FavouriteFAQItems.append(document.data() as NSDictionary)
                    let asd = self.FavouriteFAQItems[i]["Category"] as! String
                    let sdf = self.FavouriteFAQItems[i]["Index"] as! Int
                    self.FavouriteFAQCategory.append(asd)
                    self.FavouriteFAQIndex.append(sdf)
                    i = i + 1
                }
                self.FavouriteFAQ_Table.reloadData()
                print("FavFAQItems: \(self.FavouriteFAQItems)")
                
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return FavouriteFAQItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteFAQCell", for: indexPath)
        
        let category = FavouriteFAQCategory[indexPath.item] as String
        let index = FavouriteFAQIndex[indexPath.item] as Int
        let FAQFilterCategory = FAQjson[category] as! [NSDictionary]
        let FAQFilterCategoryIndex = FAQFilterCategory[index]
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = FAQFilterCategoryIndex["title"] as? String
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedFavIndex = FavouriteFAQItems[indexPath.item]["Index"] as! Int?
        selectedCategoryString = FavouriteFAQCategory[indexPath.item] as String
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toFavDetail", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFavDetail" {
            if let FavDetail = segue.destination as? FavouriteDetail {
                FavDetail.FavouriteFAQIndex = self.FavouriteFAQIndex
                FavDetail.FAQjson = FAQjson
                FavDetail.user = user
                FavDetail.selectedFavIndex = selectedFavIndex
                FavDetail.selectedCategoryString = self.selectedCategoryString
                
            }
        }
    }
    

}
