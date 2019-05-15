//
//  ViewController.swift
//  APSupport
//
//  Created by localadmin on 26/04/2019.
//  Copyright © 2019 Fhan Jacson. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController {
    
    @IBAction func buttonLogin(_ sender: Any) {
        searchForUserAlamo(username:"fhanjacson");
    }
    let authorName = "Fhan Jacson";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchForUserAlamo(username: String) {
        Alamofire.request("https://httpbin.org/post", method: .post)
        Alamofire.request(URL(string: "https://ptsv2.com/t/h9d51-1557906769/post")!, method: .post)
            .validate()
            .response { (response) in
                
                print("Request: \(response.request)")
                print("Response: \(response.response)")
                print("Error: \(response.error)")
                
                if let data = response.data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                        
                    } catch {
                        print("Error: ", error)
                    }
                    
                }
        }
    }

}

