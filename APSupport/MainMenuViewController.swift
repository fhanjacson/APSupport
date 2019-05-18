//
//  MainMenuViewController.swift
//  APSupport
//
//  Created by localadmin on 17/05/2019.
//  Copyright © 2019 Fhan Jacson. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class MainMenuViewController: UIViewController {
    @IBAction func buttonFAQ(_ sender: Any) {
        performSegue(withIdentifier: "toFAQMenu", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    func getFAQCategory() {
        print("getting FAQ article...")
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let chattest = ["id":"3","message": "Hello World","datetime":"2019-05-15 14:33:33", "username" : "TP045027"]
        
        ref.child("Chat").child("General").child("1").setValue(chattest)
        
        ref.child("FAQ").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let valuejson = JSON(value!)
            for i in valuejson {
                print(i.0)
            }
            //print(valuejson["APCard"]["0"]["content"])
            
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toFAQMenu" {
            getFAQCategory()
            
            
            
        }
    }
    
    
    
}
