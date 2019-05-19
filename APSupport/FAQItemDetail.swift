//
//  FAQItemDetail.swift
//  APSupport
//
//  Created by localadmin on 18/05/2019.
//  Copyright © 2019 Fhan Jacson. All rights reserved.
//

import UIKit

class FAQItemDetail: UIViewController {

    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var ContentLabel: UILabel!
    
    
    var selectedFAQItemListIndex: Int?
    var FAQItemListDict: [NSDictionary]?
    
    
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
