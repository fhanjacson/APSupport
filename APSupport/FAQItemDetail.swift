//
//  FAQItemDetail.swift
//  APSupport
//
//  Created by localadmin on 18/05/2019.
//  Copyright © 2019 Fhan Jacson. All rights reserved.
//

import UIKit
import Firebase

class FAQItemDetail: UIViewController {
    
    var FavouriteFAQItems = [NSDictionary]()
    var FavouriteFAQCategory = [String]()
    var FavouriteFAQIndex = [Int]()
    var isFavourite: Bool = false
    var selectedFAQItemListIndex: Int!
    var FAQItemListDict: [NSDictionary]?
    var articleBookmarked: Bool = false
    var user = Profile()
    var selectedFAQCategoryItem: String = ""
    
    func getFavStatus() {
        let db = Firestore.firestore()
        let documentName = self.selectedFAQCategoryItem + String(self.selectedFAQItemListIndex)
        db.collection("Favourite").document(user.Username).collection("FAQ").document(documentName).addSnapshotListener {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if (querySnapshot?.exists)! {
                    print("Bookmark Status: true")
                    self.articleBookmarked = true
                    self.buttonBookmark.setImage(UIImage(named: "Bookmarked"), for: .normal)
                } else {
                    print("Bookmark Status: false")
                    self.articleBookmarked = false
                    
                    self.buttonBookmark.setImage(UIImage(named: "Bookmark"), for: .normal)                }
            }
        }
        
    }
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var ContentLabel: UILabel!
    @IBOutlet weak var buttonBookmark: UIButton!
    @IBAction func buttonBookmark(_ sender: Any) {
        print("Button Bookmark Clicked")
        if articleBookmarked{
            //print("Bookmark Status: false")
            //articleBookmarked = false
            unfavFAQ()
            //buttonBookmark.setImage(UIImage(named: "Bookmark"), for: .normal)
        } else {
            //print("Bookmark Status: true")
            //articleBookmarked = true
            favFAQ()
            //buttonBookmark.setImage(UIImage(named: "Bookmarked"), for: .normal)
        }
    }
    
    func favFAQ() {
        let data : [String : Any] = ["username" : user.Username, "Category" : selectedFAQCategoryItem, "Index" : (selectedFAQItemListIndex)]
        let db = Firestore.firestore()
        let documentName = selectedFAQCategoryItem + String(selectedFAQItemListIndex)
        db.collection("Favourite").document(user.Username).collection("FAQ").document(documentName).setData(data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func unfavFAQ() {
        let db = Firestore.firestore()
        let documentName = selectedFAQCategoryItem + String(selectedFAQItemListIndex)
        db.collection("Favourite").document(user.Username).collection("FAQ").document(documentName).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TitleLabel.numberOfLines = 0
        ContentLabel.numberOfLines = 0
        
        TitleLabel.text = FAQItemListDict![selectedFAQItemListIndex!]["title"] as! String
        ContentLabel.text = FAQItemListDict![selectedFAQItemListIndex!]["content"] as! String
        
        getFavStatus()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
