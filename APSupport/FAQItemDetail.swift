//
//  FAQItemDetail.swift
//  APSupport
//
//  Created by localadmin on 18/05/2019.
//  Copyright © 2019 Fhan Jacson. All rights reserved.
//

import UIKit
import SQLite


class FAQItemDetail: UIViewController {

    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var ContentLabel: UILabel!
    @IBOutlet weak var buttonBookmark: UIButton!
    @IBAction func buttonBookmark(_ sender: Any) {
        print("Button Bookmark Clicked")
        if articleBookmarked{
            print("Bookmark Status: false")
            articleBookmarked = false
            
            
            buttonBookmark.setImage(UIImage(named: "Bookmark"), for: .normal)
        } else {
           print("Bookmark Status: true")
            articleBookmarked = true
            buttonBookmark.setImage(UIImage(named: "Bookmarked"), for: .normal)
        }
    }
    
    
    var selectedFAQItemListIndex: Int?
    var FAQItemListDict: [NSDictionary]?
    var articleBookmarked: Bool = false
    var user = Profile()
    var selectedFAQCategoryItem: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TitleLabel.numberOfLines = 2
        ContentLabel.numberOfLines = 0
        
        TitleLabel.text = FAQItemListDict![selectedFAQItemListIndex!]["title"] as! String
        ContentLabel.text = FAQItemListDict![selectedFAQItemListIndex!]["content"] as! String

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
