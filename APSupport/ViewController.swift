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
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBAction func buttonLogin(_ sender: Any) {
        if ((textUsername.text != nil) && (textPassword.text != nil)){
            
        var username = textUsername.text
        var password = textPassword.text
            APKeyLogin(username: username!, password: password!)
        }
    }
    let authorName = "Fhan Jacson";
    
    @IBAction func buttonSkipLogin(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func APKeyLogin(username: String, password: String) {
        var ticket1: String = ""
        var ticket2: String = ""
        var isAuthenticated: Bool = false;
        
        let parameters = [
            "username" : username,
            "password" : password
        ]
        
        let headers: HTTPHeaders = [
            "Accept":"application/json, text/plain, */*",
            "Content-type":"application/x-www-form-urlencoded",
            "Origin":"https://apspace.apu.edu.my",
            "Referer":"https://apspace.apu.edu.my/",
            "User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.109 Safari/537.36"
        ]
        
        //Alamofire.request(URL(string: "https://postman-echo.com/post")!, method: .post, parameters: parameters)
        Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/v1/tickets")!, method: .post, parameters:parameters, headers:headers)
            .validate()
            .response { (response) in
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                    ticket1 = utf8Text;
                    Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/v1/tickets/" + ticket1 + "?service=https://cas.apiit.edu.my")!, method: .post, headers:headers)
                        .validate()
                        .response { (response) in
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                print("Data: \(utf8Text)") // original server data as UTF8 string
                                ticket2 = utf8Text
                                Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/p3/serviceValidate?format=json&service=https://cas.apiit.edu.my&ticket=" + ticket2)!, method: .get, headers:headers)
                                    .validate()
                                    .response { (response) in
                                        if let data = response.data {
                                            do {
                                                let json = try JSONSerialization.jsonObject(with: data, options: [])
                                                print(json)
                                                
                                                if let dictionary = json as? [String: Any] {
                                                    if let serviceResponse = dictionary["serviceResponse"] as? [String: Any]{
                                                        if let authenticationSuccess = serviceResponse["authenticationSuccess"] as? [String: Any] {
                                                            if let attributes = authenticationSuccess["attributes"] as? [String: Any] {
                                                                print("User: \(attributes["user"])")
                                                            }
                                                        }
                                                    }
                                                    
                                                    for (key, value) in dictionary {
                                                        // access all key / value pairs in dictionary
                                                    }
                                                    
                                                    if let nestedDictionary = dictionary["anotherKey"] as? [String: Any] {
                                                        // access nested dictionary values by key
                                                    }
                                                }
                                                
                                                
                                            } catch {
                                                print("Error: ", error)
                                            }
                                        }
                                }
                            }
                    }
                }
                
        }
//        Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/v1/tickets/" + ticket1 + "?service=https://cas.apiit.edu.my")!, method: .post, headers:headers)
//            .validate()
//            .response { (response) in
//                print("Request: \(response.request)")
//                print("Response: \(response.response)")
//                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                    print("Data: \(utf8Text)") // original server data as UTF8 string
//                    ticket2 = utf8Text
//                }
//        }
//
//        Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/p3/serviceValidate?format=json&service=https://cas.apiit.edu.my&ticket=" + ticket2)!, method: .get, headers:headers)
//            .validate()
//            .response { (response) in
//                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                    print("Data: \(utf8Text)") // original server data as UTF8 string
//                    ticket2 = utf8Text
//                }
//                if let data = response.data {
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: data, options: [])
//                        print(json)
//                    } catch {
//                        print("Error: ", error)
//                    }
//                }
//        }
    }
    
}

