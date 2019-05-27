//
//  FavouriteDetail.swift
//  APSupport
//
//  Created by Jacson on 24/05/2019.
//  Copyright © 2019 Fhan Jacson. All rights reserved.
//

import UIKit
import Firebase

class FavouriteDetail: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var buttonFav: UIButton!
    @IBAction func buttonFav_Click(_ sender: Any) {
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
    
    var articleBookmarked: Bool = false
    var FavouriteFAQItems = [NSDictionary]()
    var FavouriteFAQCategory = [String]()
    var FavouriteFAQIndex = [Int]()
    var user = Profile()
    var FAQjson: NSDictionary = NSDictionary()
    var selectedFavIndex : Int!
    var selectedCategoryString: String = ""
    
    func favFAQ() {
        let data : [String : Any] = ["username" : user.Username, "Category" : selectedCategoryString, "Index" : selectedFavIndex]
        let db = Firestore.firestore()
        let documentName =  (selectedCategoryString) + String(selectedFavIndex)
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
        
        let documentName =  (selectedCategoryString) + String(selectedFavIndex)
        db.collection("Favourite").document(user.Username).collection("FAQ").document(documentName).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }    }
    
    func getFavStatus() {
        let db = Firestore.firestore()
        
        let documentName =  (selectedCategoryString) + String(selectedFavIndex)
        print(documentName)
        db.collection("Favourite").document(user.Username).collection("FAQ").document(documentName).addSnapshotListener {
            (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if (querySnapshot?.exists)! {
                    print("Bookmark Status: true")
                    self.articleBookmarked = true
                    
                    self.buttonFav.setImage(UIImage(named: "Bookmarked"), for: .normal)
                } else {
                    print("Bookmark Status: false")
                    self.articleBookmarked = false
                    
                    self.buttonFav.setImage(UIImage(named: "Bookmark"), for: .normal)
                    
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("#FavouriteFAQ")
        labelTitle.numberOfLines = 0
        labelContent.numberOfLines = 0
        
//        let category = FavouriteFAQCategory[selectedFavIndex!] as String
        print("selectedFavIndex: \(selectedFavIndex)")
        //let index = FavouriteFAQIndex[selectedFavIndex!] as Int
        let FAQFilterCategory = FAQjson[selectedCategoryString] as! [NSDictionary]
        let FAQFilterCategoryIndex = FAQFilterCategory[selectedFavIndex + 1]
        
        labelTitle.text = FAQFilterCategoryIndex["title"] as? String
        labelContent.text = FAQFilterCategoryIndex["content"] as? String
        
        print("#GetFavStatus")
        getFavStatus()
        print("#end")
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
